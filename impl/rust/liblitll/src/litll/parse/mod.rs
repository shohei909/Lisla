use super::*;
use super::util::is_blacklisted_whitespace;
use super::tag::*;

use std::char;
use std::str::Chars;
use std::mem::replace;
use std::ops::Range;


pub mod error;
mod context;
mod tag_write;

use self::context::*;
use self::error::*;
use self::tag_write::*;

use rustc_serialize::hex::FromHex;


// ===============================================================================
// Macro
// ===============================================================================

macro_rules! error(
    ($parser:ident, $error:expr) => {{
        let error = $error;
        let fatal: bool = error.fatal;
        $parser.errors.push(error);
        if !$parser.config.is_persevering || fatal {
            return Result::Err(());
        }
    }};
);

macro_rules! maybe(
    ($option:expr) => {{
        match $option {
            Option::Some(data) => data,
            Option::None => return Result::Err(()),
        }
    }};
);




// ===============================================================================
// Config
// ===============================================================================

#[derive(Debug)]
pub struct Config {
    pub is_persevering: bool,
    pub collects_position: bool,
    pub collects_document: bool,
}

impl Config {
    pub fn new() -> Self {
        Config {
            is_persevering: false,
            collects_position: false,
            collects_document: false,
        }
    }
}



// ===============================================================================
// Parser structure
// ===============================================================================

pub struct Parser<'a> {
    config: &'a Config,
    position: usize,
    output: OutputArray,
    stack: Vec<OutputArray>,
    errors: Vec<ErrorEntry>,
    context: Option<Context>,
}

type OutputArray = (Vec<Litll>, TagWriter<ArrayTag>);



// ===============================================================================
// Parser impl
// ===============================================================================

pub fn parse(chars: Chars, config: &Config) -> Result<LitllArray, Error> {
    let mut parser = Parser::new(&config);

    for character in chars {
        if parser.process(character).is_err() {
            return Result::Err(Error {
                data: Option::None,
                entries: parser.errors,
            });
        }
    }

    parser.end()
}

impl<'a> Parser<'a> {
    pub fn new(config: &'a Config) -> Self {
        Parser {
            position: 0,
            output: (vec![], TagWriter::new()),
            config: config,
            stack: vec![],
            errors: vec![],
            context: Option::Some(Context::Array(ArrayContext::Normal)),
        }
    }

    // ---------------------------------------------------
    // Process
    // ---------------------------------------------------
    #[inline]
    pub fn process(&mut self, character: char) -> Result<(), ()> {
        self.position += 1;
        let current_context = maybe!(replace(&mut self.context, Option::None));
        self.context = Option::Some(try!(self.process_context(character, current_context)));
        Result::Ok(())
    }

    #[inline]
    fn process_context(&mut self,
                       character: char,
                       current_context: Context)
                       -> Result<Context, ()> {

        match current_context {
            Context::Array(detail) => self.process_array(character, detail),
            Context::OpeningQuote(quote, length) => {
                self.process_opening_quote(character, quote, length)
            }
            Context::QuotedString(detail) => self.process_quoted_string(character, detail),
            Context::UnquotedString(detail) => self.process_unquoted_string(character, detail),
            Context::Comment(detail) => self.process_comment(character, detail),
        }
    }

    #[inline]
    fn process_array(&mut self, character: char, detail: ArrayContext) -> Result<Context, ()> {
        if let ArrayContext::Slash(length) = detail {
            let context: Context = if character == '/' {
                if length == 3 {
                    let (_, ref mut tag) = self.output;
                    tag.write_document(self.config, character, self.position);
                    return Result::Ok(Context::Comment(CommentContext {
                        keeping: false,
                        document: true,
                    }));
                }

                Context::Array(ArrayContext::Slash(length + 1))
            } else {
                if length == 1 {
                    let mut next_detail = self.start_unquoted_string_context();
                    next_detail.string.push('/');
                    try!(self.process_unquoted_string(character, next_detail))
                } else if length == 2 || length == 3 {
                    let document = length == 3;
                    let keeping = character == '!';
                    if document && !keeping {
                        let (_, ref mut tag) = self.output;
                        tag.write_document(self.config, character, self.position);
                    }
                    Context::Comment(CommentContext {
                        keeping: keeping,
                        document: document,
                    })
                } else {
                    panic!("too long slash");
                }
            };

            return Result::Ok(context);
        }

        let context = match character {
            ' ' | '\t' | '\n' => Context::Array(ArrayContext::Normal),
            '\r' => Context::Array(ArrayContext::CarriageReturn),

            '[' => self.start_array(),

            ']' => {
                if let Some(next_output) = self.stack.pop() {
                    self.end_array(next_output);
                } else {
                    let p = self.position;
                    error!(self,
                           ErrorEntry::new(ErrorKind::ExtraClosingBracket, (p - 1)..p, false));
                }

                Context::Array(ArrayContext::Normal)
            }

            '/' => Context::Array(ArrayContext::Slash(1)),

            _ => {
                if let ArrayContext::NotSeparated = detail {
                    let p = self.position;
                    error!(self,
                           ErrorEntry::new(ErrorKind::SeparatorRequired, (p - 1)..p, false));
                }

                match character {
                    '\"' => Context::OpeningQuote(QuoteChar::Double, 1),
                    '\'' => Context::OpeningQuote(QuoteChar::Single, 1),

                    _ => {
                        let next_detail = self.start_unquoted_string_context();
                        try!(self.process_unquoted_string(character, next_detail))
                    }
                }
            }
        };

        Result::Ok(context)
    }

    #[inline]
    fn start_array(&mut self) -> Context {
        let tag = {
            let (_, ref mut tag) = self.output;
            tag.pop_for_array(self.config, self.position)
        };

        let output = replace(&mut self.output, (vec![], tag));
        self.stack.push(output);

        Context::Array(ArrayContext::Normal)
    }

    #[inline]
    fn process_opening_quote(&mut self,
                             character: char,
                             quote: QuoteChar,
                             length: usize)
                             -> Result<Context, ()> {
        if quote.is_match(character) {
            return Result::Ok(Context::OpeningQuote(quote, length + 1));
        }

        let tmp_context = self.end_opening_quote(quote, length);
        Result::Ok(try!(self.process_context(character, tmp_context)))
    }

    #[inline]
    fn start_unquoted_string_context(&mut self) -> UnquotedStringContext {
        let (_, ref mut tag) = self.output;

        UnquotedStringContext {
            string: String::new(),
            inline_context: UnquotedStringInlineContext::Body(false),
            tag: tag.pop_for_string(self.config, self.position, QuoteKind::Unquoted),
        }
    }

    #[inline]
    fn process_quoted_string(&mut self,
                             character: char,
                             mut detail: QuotedStringContext)
                             -> Result<Context, ()> {

        detail.inline_context = match detail.inline_context {
            QuotedStringInlineContext::EscapeSequence(escape_sequence) => {
                match try!(self.process_escape_sequence(character, escape_sequence)) {
                    EscapeSequenceOperation::Continue(next_escape_sequence) => {
                        QuotedStringInlineContext::EscapeSequence(next_escape_sequence)
                    }

                    EscapeSequenceOperation::End(character) => {
                        let (ref mut line, _, _) = *detail.lines.last_mut().unwrap();
                        line.push(character);
                        QuotedStringInlineContext::Body
                    }
                }
            }

            QuotedStringInlineContext::CarriageReturn => {
                match character {
                    '\n' => {
                        self.new_line_quoted_string(NewLineChar::CrLf, &mut detail);
                        QuotedStringInlineContext::Indent
                    }
                    _ => {
                        self.new_line_quoted_string(NewLineChar::Cr, &mut detail);
                        try!(self.process_quoted_string_indent(character, &mut detail))
                    }
                }
            }

            QuotedStringInlineContext::Indent => {
                try!(self.process_quoted_string_indent(character, &mut detail))
            }

            QuotedStringInlineContext::Quotes(length) => {
                if detail.quote.is_match(character) {
                    QuotedStringInlineContext::Quotes(length + 1)
                } else if length < detail.opening_quotes {
                    self.add_quotes(length, &mut detail);
                    try!(self.process_quoted_string_body(character, &mut detail))
                } else {
                    try!(self.end_closed_quoted_string(length, detail));
                    return self.process_array(character, ArrayContext::NotSeparated);
                }
            }

            QuotedStringInlineContext::Body => {
                try!(self.process_quoted_string_body(character, &mut detail))
            }
        };

        Result::Ok(Context::QuotedString(detail))
    }

    fn add_quotes(&mut self, length: usize, detail: &mut QuotedStringContext) {
        let (ref mut line, _, _) = *detail.lines.last_mut().unwrap();
        for _ in 0..length {
            detail.quote.write_to(line);
        }
    }

    #[inline]
    fn process_quoted_string_indent(&mut self,
                                    character: char,
                                    detail: &mut QuotedStringContext)
                                    -> Result<QuotedStringInlineContext, ()> {
        let context = match character {
            ' ' | '\t' => {
                let (ref mut line, _, ref mut i) = *detail.lines.last_mut().unwrap();
                *i += 1;
                line.push(character);
                QuotedStringInlineContext::Indent
            }
            _ => try!(self.process_quoted_string_body(character, detail)),
        };

        Result::Ok(context)
    }

    #[inline]
    fn process_quoted_string_body(&mut self,
                                  character: char,
                                  detail: &mut QuotedStringContext)
                                  -> Result<QuotedStringInlineContext, ()> {
        let context = if detail.quote.is_match(character) {
            QuotedStringInlineContext::Quotes(1)
        } else {
            match character {
                '\\' if detail.quote.is_match('"') => {
                    QuotedStringInlineContext::EscapeSequence(EscapeSequenceContext::Head)
                }

                '\n' => {
                    self.new_line_quoted_string(NewLineChar::Lf, detail);
                    QuotedStringInlineContext::Indent
                }

                '\r' => QuotedStringInlineContext::CarriageReturn,

                _ => {
                    let (ref mut line, _, _) = *detail.lines.last_mut().unwrap();
                    line.push(character);
                    QuotedStringInlineContext::Body
                }
            }
        };

        Result::Ok(context)
    }

    fn new_line_quoted_string(&self, character: NewLineChar, detail: &mut QuotedStringContext) {
        {
            let (_, ref mut new_line, _) = *detail.lines.last_mut().unwrap();
            *new_line = Option::Some(character);
        }

        detail.lines.push((String::new(), Option::None, 0));
    }

    fn process_unquoted_string(&mut self,
                               character: char,
                               mut detail: UnquotedStringContext)
                               -> Result<Context, ()> {

        detail.inline_context = match detail.inline_context {
            UnquotedStringInlineContext::EscapeSequence(sequence_detail) => {
                let next_inline_context =
                    match try!(self.process_escape_sequence(character, sequence_detail)) {
                        EscapeSequenceOperation::Continue(next_sequence_detail) => {
                            UnquotedStringInlineContext::EscapeSequence(next_sequence_detail)
                        }

                        EscapeSequenceOperation::End(escaped_character) => {
                            detail.string.push(escaped_character);
                            UnquotedStringInlineContext::Body(false)
                        }
                    };

                next_inline_context
            }

            UnquotedStringInlineContext::Body(is_slash) => {
                if is_slash {
                    if character == '/' {
                        self.end_unquoted_string_body(detail);
                        return Result::Ok(Context::Array(ArrayContext::Slash(2)));
                    } else {
                        detail.string.push('/')
                    }
                }

                match try!(self.process_unquoted_string_body(character, &mut detail)) {
                    UnquotedStringOperation::Continue(next_inline_context) => next_inline_context,

                    UnquotedStringOperation::End => {
                        self.end_unquoted_string_body(detail);
                        return self.process_array(character, ArrayContext::NotSeparated);
                    }
                }
            }
        };

        Result::Ok(Context::UnquotedString(detail))
    }

    fn process_unquoted_string_body(&mut self,
                                    character: char,
                                    detail: &mut UnquotedStringContext)
                                    -> Result<UnquotedStringOperation, ()> {

        let operation = if is_blacklisted_whitespace(character) {
            let p = self.position;
            error!(self,
                   ErrorEntry::new(ErrorKind::BlacklistedWhitespace(character),
                                   (p - 1)..p,
                                   false));

            detail.string.push(character);
            UnquotedStringOperation::Continue(UnquotedStringInlineContext::Body(false))
        } else {
            match character {
                ' ' | '\t' | '\n' | '\r' | '[' | ']' => UnquotedStringOperation::End,

                '/' => UnquotedStringOperation::Continue(UnquotedStringInlineContext::Body(true)),

                '\"' | '\'' => {
                    let p = self.position;
                    error!(self,
                           ErrorEntry::new(ErrorKind::SeparatorRequired, (p - 1)..p, false));

                    UnquotedStringOperation::End
                }

                '\\' => {
                    UnquotedStringOperation::Continue(UnquotedStringInlineContext::EscapeSequence(EscapeSequenceContext::Head))
                }
                _ => {
                    detail.string.push(character);
                    UnquotedStringOperation::Continue(UnquotedStringInlineContext::Body(false))
                }
            }
        };

        Result::Ok(operation)
    }

    fn process_escape_sequence(&mut self,
                               character: char,
                               detail: EscapeSequenceContext)
                               -> Result<EscapeSequenceOperation, ()> {

        let operation = match detail {
            EscapeSequenceContext::Head => {
                match character {
                    'u' => {
                        let context = EscapeSequenceContext::Unicode(None);
                        EscapeSequenceOperation::Continue(context)
                    }

                    'n' => EscapeSequenceOperation::End('\n'),
                    'r' => EscapeSequenceOperation::End('\r'),
                    't' => EscapeSequenceOperation::End('\t'),
                    '0' => EscapeSequenceOperation::End('\0'),
                    '\\' => EscapeSequenceOperation::End('\\'),
                    '\'' => EscapeSequenceOperation::End('\''),
                    '\"' => EscapeSequenceOperation::End('\"'),

                    _ => {
                        try!(self.interrupt_escape_sequence(Option::Some(character), detail));
                        EscapeSequenceOperation::End(character)
                    } 
                }
            }

            EscapeSequenceContext::Unicode(None) => {
                if character == '{' {
                    let context = EscapeSequenceContext::Unicode(Some(String::new()));
                    EscapeSequenceOperation::Continue(context)
                } else {
                    try!(self.interrupt_escape_sequence(Option::Some(character), detail));
                    EscapeSequenceOperation::End(character)
                }
            }

            EscapeSequenceContext::Unicode(Some(mut string)) => {
                match character {
                    '0'...'9' | 'A'...'F' | 'a'...'f' => {
                        string.push(character);
                        let next_detail = EscapeSequenceContext::Unicode(Some(string));
                        EscapeSequenceOperation::Continue(next_detail)
                    }

                    '}' => {
                        let len = string.len();
                        if len < 1 || 6 < len {
                            let p = self.position;
                            error!(self,
                                   ErrorEntry {
                                       position: (p - len - 3)..p,
                                       kind: ErrorKind::InvalidDigitUnicodeEscape,
                                       fatal: false,
                                   });
                            EscapeSequenceOperation::End('u')
                        } else {
                            let maybe_character = string.from_hex().ok().and_then(|bytes| {
                                let code = bytes.into_iter()
                                                .fold(0u32, |val, byte| val << 8 | byte as u32);

                                char::from_u32(code)
                            });

                            let escaped_character = match maybe_character {
                                Some(c) => c,
                                None => {
                                    let p = self.position;
                                    error!(self,
                                           ErrorEntry {
                                               position: (p - len - 3)..p,
                                               kind: ErrorKind::InvalidUnicode,
                                               fatal: false,
                                           });
                                    'u'
                                }
                            };

                            EscapeSequenceOperation::End(escaped_character)
                        }
                    }

                    _ => {
                        let next_detail = EscapeSequenceContext::Unicode(Some(string));
                        try!(self.interrupt_escape_sequence(Option::Some(character), next_detail));
                        EscapeSequenceOperation::End('u')
                    }
                }
            }
        };

        Result::Ok(operation)
    }

    fn process_comment(&mut self, character: char, detail: CommentContext) -> Result<Context, ()> {
        let context = match character {
            '\n' | '\r' => try!(self.process_array(character, ArrayContext::Normal)),
            _ => Context::Comment(detail),
        };

        Result::Ok(context)
    }


    // ---------------------------------------------------
    // End
    // ---------------------------------------------------
    #[inline]
    pub fn end(mut self) -> Result<LitllArray, Error> {
        self.position += 1;

        if self.end_context().is_err() {
            return Result::Err(Error {
                data: Option::None,
                entries: self.errors,
            });
        }

        let (output_vec, tag) = self.output;
        let data = LitllArray {
            data: output_vec,
            tag: tag.end(self.position),
        };

        if !self.errors.is_empty() {
            return Result::Err(Error {
                data: Option::Some(data),
                entries: self.errors,
            });
        }

        Result::Ok(data)
    }

    fn end_context(&mut self) -> Result<(), ()> {
        let mut context = maybe!(replace(&mut self.context, Option::None));

        loop {
            context = match context {
                Context::Array(_) => {
                    break;
                }
                Context::OpeningQuote(quote, length) => self.end_opening_quote(quote, length),
                Context::QuotedString(detail) => {
                    try!(self.end_quoted_string(detail));
                    Context::Array(ArrayContext::NotSeparated)
                }
                Context::UnquotedString(detail) => {
                    try!(self.end_unquoted_string(detail));
                    Context::Array(ArrayContext::NotSeparated)
                }
                Context::Comment(_) => Context::Array(ArrayContext::Normal),
            }
        }

        while let Some(next_output) = self.stack.pop() {
            let p = self.position;
            error!(self,
                   ErrorEntry {
                       kind: ErrorKind::UnclosedArray,
                       position: (p - 1)..p,
                       fatal: false,
                   });

            self.end_array(next_output);
        }

        Result::Ok(())
    }

    fn end_array(&mut self, next_output: OutputArray) {
        let old_output = replace(&mut self.output, next_output);

        let (ref mut output_vec, _) = self.output;
        let (arr, tag) = old_output;

        let data = Litll::Array(LitllArray {
            data: arr,
            tag: tag.end(self.position),
        });

        output_vec.push(data);
    }

    fn end_opening_quote(&mut self, quote: QuoteChar, length: usize) -> Context {
        let (ref mut output_vec, ref mut tag) = self.output;

        if length == 2 {
            {
                let data = Litll::String(LitllString {
                    data: String::new(),
                    tag: tag.pop_for_string(self.config,
                                            self.position - 2,
                                            QuoteKind::Quoted(quote, 1))
                            .end(self.position),
                });
                output_vec.push(data);
            }
            Context::Array(ArrayContext::NotSeparated)
        } else {
            Context::QuotedString(QuotedStringContext {
                lines: vec![(String::new(), Option::None, 0)],
                quote: quote,
                start_position: self.position - 1,
                inline_context: QuotedStringInlineContext::Indent,
                opening_quotes: length,
                tag: tag.pop_for_string(self.config,
                                        self.position - length,
                                        QuoteKind::Quoted(quote, length)),
            })
        }
    }

    fn end_quoted_string(&mut self, mut detail: QuotedStringContext) -> Result<(), ()> {
        match detail.inline_context {
            QuotedStringInlineContext::CarriageReturn => {
                self.new_line_quoted_string(NewLineChar::Cr, &mut detail);
                try!(self.end_unclosed_quoted_string(0, detail))
            }

            QuotedStringInlineContext::Body | QuotedStringInlineContext::Indent => {
                try!(self.end_unclosed_quoted_string(0, detail))
            }
            QuotedStringInlineContext::Quotes(length) => {
                if length < detail.opening_quotes {
                    try!(self.end_unclosed_quoted_string(length, detail));
                } else {
                    try!(self.end_closed_quoted_string(length, detail));
                }
            }
            QuotedStringInlineContext::EscapeSequence(detail) => {
                try!(self.interrupt_escape_sequence(Option::None, detail))
            }
        }

        Result::Ok(())
    }

    fn end_closed_quoted_string(&mut self,
                                length: usize,
                                mut detail: QuotedStringContext)
                                -> Result<(), ()> {

        if length > detail.opening_quotes {
            let p = self.position;
            error!(self,
                   ErrorEntry::new(ErrorKind::TooManyClosingQuotes, (p - length)..p, false));
        }

        let (ref mut output_vec, _) = self.output;

        let mut string = String::new();
        let mut string_position = detail.start_position;

        if let Some(last) = detail.lines.pop() {
            let mut into_iter = detail.lines.into_iter();
            if let Some(first) = into_iter.next() {
                let mut last_new_line = Option::None;

                {
                    let (line, maybe_new_line, indent) = first;
                    let new_line = maybe_new_line.unwrap();
                    string_position += line.len() + new_line.len();
                    if line.len() != indent {
                        string.push_str(&line);
                        new_line.write_to(&mut string);
                        last_new_line = Option::Some(new_line);
                    }
                };

                let (last_line, _, last_indent) = last;
                let (last_head, last_body) = last_line.split_at(last_indent);

                for (line, maybe_new_line, indent) in into_iter {
                    let new_line = maybe_new_line.unwrap();

                    string_position += line.len() + new_line.len();

                    if line.len() == 0 {
                        string.push_str(&line);
                        new_line.write_to(&mut string);
                        last_new_line = Option::Some(new_line);
                        continue;
                    }

                    let (head, body) = if indent < last_indent {
                        let p = self.position - line.len();
                        error!(self,
                               ErrorEntry::new(ErrorKind::InvalidIndent, p..(p + indent), false));

                        line.split_at(indent)
                    } else {
                        line.split_at(last_indent)
                    };

                    if last_head != head {
                        let p = self.position - body.len();
                        error!(self,
                               ErrorEntry::new(ErrorKind::InvalidIndent,
                                               (p - last_indent)..p,
                                               false));
                    }

                    string.push_str(&body);
                    new_line.write_to(&mut string);
                    last_new_line = Option::Some(new_line);
                }

                if last_body.len() == 0 {
                    if let Some(nl) = last_new_line {
                        for _ in 0..nl.len() {
                            string.pop();
                        }
                    }
                } else {
                    string.push_str(&last_body);
                }
            } else {
                let (last_line, _, _) = last;
                string.push_str(&last_line);
            }
        }

        let data = Litll::String(LitllString {
            data: string,
            tag: detail.tag.end(self.position),
        });
        output_vec.push(data);

        Result::Ok(())
    }

    fn end_unclosed_quoted_string(&mut self,
                                  length: usize,
                                  mut detail: QuotedStringContext)
                                  -> Result<(), ()> {
        self.add_quotes(detail.opening_quotes - length, &mut detail);

        let p = self.position;
        error!(self,
               ErrorEntry {
                   kind: ErrorKind::UnclosedString,
                   position: (p - 1)..p,
                   fatal: false,
               });

        self.end_closed_quoted_string(detail.opening_quotes, detail)
    }

    fn interrupt_escape_sequence(&mut self,
                                 character: Option<char>,
                                 detail: EscapeSequenceContext)
                                 -> Result<(), ()> {
        let mut string = String::from("\\");

        match detail {
            EscapeSequenceContext::Head => {}
            EscapeSequenceContext::Unicode(state) => {
                string.push('u');
                if let Some(s) = state {
                    string.push('{');
                    string.push_str(s.as_str());
                }
            }
        }

        if let Some(c) = character {
            string.push(c);
        }

        let p = self.position;
        error!(self,
               ErrorEntry {
                   position: (p - string.len())..p,
                   kind: ErrorKind::InvalidEscapeSequence(string),
                   fatal: false,
               });

        Result::Ok(())
    }

    fn end_unquoted_string(&mut self, mut detail: UnquotedStringContext) -> Result<(), ()> {
        match detail.inline_context {
            UnquotedStringInlineContext::Body(is_slash) => {
                {
                    let ref mut string = detail.string;
                    if is_slash {
                        string.push('/');
                    }
                }
                self.end_unquoted_string_body(detail);
            }

            UnquotedStringInlineContext::EscapeSequence(detail) => {
                try!(self.interrupt_escape_sequence(Option::None, detail));
            }
        }

        Result::Ok(())
    }

    fn end_unquoted_string_body(&mut self, detail: UnquotedStringContext) {
        let string = detail.string;
        let (ref mut output_vec, _) = self.output;
        let data = Litll::String(LitllString {
            data: string,
            tag: detail.tag.end(self.position),
        });
        output_vec.push(data);
    }
}
