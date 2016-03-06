use super::string::Trim;
use super::data::*;

use std::str::Chars;
use std::mem::replace;
use std::ops::Range;

pub mod error;
mod data;
mod tag;

use self::data::*;
use self::error::*;
use self::tag::*;



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
// Tag
// ===============================================================================

#[derive(Debug)]
pub struct Tag {
    pub position: Option<Range<i64>>,
    pub document: Option<Document>,
}



// ===============================================================================
// Document
// ===============================================================================

#[derive(Debug)]
pub struct Document {
    pub content: Box<ArrData<Tag>>,
    pub source_map: Vec<Range<i64>>,
}




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
    position: i64,
    output: OutputArray,
    stack: Vec<OutputArray>,
    extra_tag: TagWriter<TagWriterNotStarted>,
    errors: Vec<ErrorDetail>,
    context: Option<Context>,
}



// ===============================================================================
// Parser impl
// ===============================================================================

pub fn parse(chars: Chars, config: &Config) -> Result<ArrData<Tag>, Error> {
    let mut parser = Parser::new(&config);

    for character in chars {
        if parser.process(character).is_err() {
            return Result::Err(Error {
                data: Option::None,
                details: parser.errors,
            });
        }
    }

    parser.end()
}

impl<'a> Parser<'a> {
    pub fn new(config: &'a Config) -> Self {
        Parser {
            position: 0,
            output: (vec![], TagWriter::new().start(config, 0)),
            extra_tag: TagWriter::new(),
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
                    self.extra_tag.write_document(self.config, character);
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
                        self.extra_tag.write_document(self.config, character);
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
            ',' | ' ' | '\t' | '\n' | '\r' => Context::Array(ArrayContext::Normal),

            '[' => self.start_array(),

            ']' => {
                if let Some(next_output) = self.stack.pop() {
                    self.end_array(next_output);
                } else {
                    let p = self.position;
                    error!(self,
                           ErrorDetail::new(ErrorKind::ExtraClosingBracket, (p - 1)..p, false));
                }

                Context::Array(ArrayContext::Normal)
            }

            '/' => Context::Array(ArrayContext::Slash(1)),

            _ => {
                if let ArrayContext::NotSeparated = detail {
                    let p = self.position;
                    error!(self,
                           ErrorDetail::new(ErrorKind::SeparatorRequired, (p - 1)..p, false));
                }

                match character {
                    '\"' | '\'' => Context::OpeningQuote(character, 1),

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
        let tag = replace(&mut self.extra_tag, TagWriter::new());
        let output = replace(&mut self.output,
                             (vec![], tag.start(self.config, self.position)));
        self.stack.push(output);

        Context::Array(ArrayContext::Normal)
    }

    #[inline]
    fn process_opening_quote(&mut self,
                             character: char,
                             quote: char,
                             length: i64)
                             -> Result<Context, ()> {
        if character == quote {
            return Result::Ok(Context::OpeningQuote(quote, length + 1));
        }

        let tmp_context = self.end_opening_quote(quote, length);
        Result::Ok(try!(self.process_context(character, tmp_context)))
    }

    #[inline]
    fn start_unquoted_string_context(&mut self) -> UnquotedStringContext {
        let tag = replace(&mut self.extra_tag, TagWriter::new());

        UnquotedStringContext {
            string: String::new(),
            inline_context: UnquotedStringInlineContext::Body(false),
            tag: tag.start(self.config, self.position),
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
                        let (ref mut line, _) = *detail.lines.last_mut().unwrap();
                        line.push(character);
                        QuotedStringInlineContext::Body
                    }
                }
            }

            QuotedStringInlineContext::Indent => {
                match character {
                    ' ' | '\t' => {
                        let (ref mut line, ref mut i) = *detail.lines.last_mut().unwrap();
                        *i += 1;
                        line.push(character);
                        QuotedStringInlineContext::Indent
                    }

                    _ => try!(self.process_quoted_string_body(character, &mut detail)),
                }
            }

            QuotedStringInlineContext::Quotes(length) => {
                if character == detail.quote {
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

    fn add_quotes(&mut self, length: i64, detail: &mut QuotedStringContext) {
        let (ref mut line, _) = *detail.lines.last_mut().unwrap();
        for _ in 0..length {
            line.push(detail.quote);
        }
    }

    #[inline]
    fn process_quoted_string_body(&mut self,
                                  character: char,
                                  detail: &mut QuotedStringContext)
                                  -> Result<QuotedStringInlineContext, ()> {
        let context = if character == detail.quote {
            QuotedStringInlineContext::Quotes(1)
        } else {
            {
                let (ref mut line, _) = *detail.lines.last_mut().unwrap();
                line.push(character);
            }

            match character {
                '\\' => QuotedStringInlineContext::EscapeSequence(EscapeSequenceContext::Head),

                '\r' | '\n' => {
                    detail.lines.push((String::new(), 0));
                    QuotedStringInlineContext::Indent
                }

                _ => QuotedStringInlineContext::Body,
            }
        };

        Result::Ok(context)
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
                        self.end_unquoted_string(detail);
                        return Result::Ok(Context::Array(ArrayContext::Slash(2)));
                    } else {
                        detail.string.push('/')
                    }
                }

                match try!(self.process_unquoted_string_body(character, &mut detail)) {
                    UnquotedStringOperation::Continue(next_inline_context) => next_inline_context,

                    UnquotedStringOperation::End => {
                        self.end_unquoted_string(detail);
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
                   ErrorDetail::new(ErrorKind::BlacklistedWhitespace(character),
                                    (p - 1)..p,
                                    false));

            detail.string.push(character);
            UnquotedStringOperation::Continue(UnquotedStringInlineContext::Body(false))
        } else {
            match character {
                ',' | ' ' | '\t' | '\n' | '\r' | '[' | ']' => UnquotedStringOperation::End,

                '/' => UnquotedStringOperation::Continue(UnquotedStringInlineContext::Body(true)),

                '\\' => {
                    UnquotedStringOperation::Continue(UnquotedStringInlineContext::EscapeSequence(EscapeSequenceContext::Head))
                }

                '\"' | '\'' => {
                    let p = self.position;
                    error!(self,
                           ErrorDetail::new(ErrorKind::SeparatorRequired, (p - 1)..p, false));

                    UnquotedStringOperation::End
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
                        let p = self.position;
                        let mut string = String::new();
                        string.push(character);
                        error!(self,
                               ErrorDetail::new(ErrorKind::InvalidEscapeSequence(string),
                                                (p - 2)..p,
                                                false));

                        EscapeSequenceOperation::End(character)
                    } 
                }
            }

            EscapeSequenceContext::Unicode(None) => {
                if character == '{' {
                    let context = EscapeSequenceContext::Unicode(Some(String::new()));
                    EscapeSequenceOperation::Continue(context)
                } else {
                    let p = self.position;
                    let mut string = String::new();
                    string.push(character);
                    error!(self,
                           ErrorDetail::new(ErrorKind::InvalidEscapeSequence(string),
                                            (p - 2)..p,
                                            false));

                    EscapeSequenceOperation::End(character)
                }
            }

            EscapeSequenceContext::Unicode(Some(mut string)) => {
                string.push(character);
                let context = EscapeSequenceContext::Unicode(Some(string));
                EscapeSequenceOperation::Continue(context)
            }
        };

        Result::Ok(operation)
    }

    fn process_comment(&mut self, character: char, detail: CommentContext) -> Result<Context, ()> {
        let context = match character {
            '\n' | '\r' => Context::Array(ArrayContext::Normal),
            _ => Context::Comment(detail),
        };

        Result::Ok(context)
    }


    // ---------------------------------------------------
    // End
    // ---------------------------------------------------
    #[inline]
    pub fn end(mut self) -> Result<ArrData<Tag>, Error> {
        self.position += 1;

        if self.end_context().is_err() {
            return Result::Err(Error {
                data: Option::None,
                details: self.errors,
            });
        }

        let (output_vec, tag) = self.output;
        let extra_tag = replace(&mut self.extra_tag, TagWriter::new());
        let data = ArrData {
            data: output_vec,
            tag: tag.end(self.position),
            extra_tag: extra_tag.interrupt(self.position),
        };

        if !self.errors.is_empty() {
            return Result::Err(Error {
                data: Option::Some(data),
                details: self.errors,
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
                    self.end_unquoted_string(detail);
                    Context::Array(ArrayContext::NotSeparated)
                }
                Context::Comment(_) => Context::Array(ArrayContext::Normal),
            }
        }

        while let Some(next_output) = self.stack.pop() {
            let p = self.position;
            error!(self,
                   ErrorDetail {
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
        let old_extra_tag = replace(&mut self.extra_tag, TagWriter::new());

        let (ref mut output_vec, _) = self.output;
        let (arr, tag) = old_output;
        let data = StrOrArr::Arr(ArrData {
            data: arr,
            tag: tag.end(self.position),
            extra_tag: old_extra_tag.interrupt(self.position),
        });

        output_vec.push(data);
    }

    fn end_opening_quote(&mut self, quote: char, length: i64) -> Context {
        let tag = replace(&mut self.extra_tag, TagWriter::new());

        if length == 2 {
            {
                let (ref mut output_vec, _) = self.output;
                let data = StrOrArr::Str(StrData {
                    data: String::new(),
                    is_quoted: true,
                    tag: tag.start(self.config, self.position - 2)
                            .end(self.position),
                });
                output_vec.push(data);
            }
            Context::Array(ArrayContext::NotSeparated)
        } else {
            Context::QuotedString(QuotedStringContext {
                lines: vec![(String::new(), 0)],
                quote: quote,
                inline_context: QuotedStringInlineContext::Indent,
                opening_quotes: length,
                tag: tag.start(self.config, self.position - length),
            })
        }
    }

    fn end_quoted_string(&mut self, detail: QuotedStringContext) -> Result<(), ()> {
        match detail.inline_context {
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
                try!(self.end_escape_sequence(detail))
            }
        }

        Result::Ok(())
    }

    fn end_closed_quoted_string(&mut self,
                                length: i64,
                                detail: QuotedStringContext)
                                -> Result<(), ()> {
        if length > detail.opening_quotes {
            let p = self.position;
            error!(self,
                   ErrorDetail::new(ErrorKind::TooManyClosingQuotes, (p - length)..p, false));
        }

        let (ref mut output_vec, _) = self.output;
        let string = detail.lines.trim();
        let data = StrOrArr::Str(StrData {
            data: string,
            is_quoted: true,
            tag: detail.tag.end(self.position),
        });
        output_vec.push(data);

        Result::Ok(())
    }

    fn end_unclosed_quoted_string(&mut self,
                                  length: i64,
                                  mut detail: QuotedStringContext)
                                  -> Result<(), ()> {
        self.add_quotes(detail.opening_quotes - length, &mut detail);

        let p = self.position;
        error!(self,
               ErrorDetail {
                   kind: ErrorKind::UnclosedString,
                   position: (p - 1)..p,
                   fatal: false,
               });

        self.end_closed_quoted_string(detail.opening_quotes, detail)
    }

    fn end_escape_sequence(&mut self, detail: EscapeSequenceContext) -> Result<(), ()> {
        let p = self.position;
        error!(self,
               ErrorDetail {
                   kind: ErrorKind::InvalidEscapeSequence(String::new()),
                   position: (p - 1)..p,
                   fatal: false,
               });
        Result::Ok(())
    }

    fn end_unquoted_string(&mut self, detail: UnquotedStringContext) {
        match detail.inline_context {
            UnquotedStringInlineContext::Body(is_slash) => {
                let mut string = detail.string;
                if is_slash {
                    string.push('/');
                }
                let (ref mut output_vec, _) = self.output;
                let data = StrOrArr::Str(StrData {
                    data: string,
                    is_quoted: false,
                    tag: detail.tag.end(self.position),
                });
                output_vec.push(data);
            }

            UnquotedStringInlineContext::EscapeSequence(detail) => {
                self.end_escape_sequence(detail);
            }
        }
    }
}

pub fn is_blacklisted_whitespace(character: char) -> bool {
    match character {
        '\u{000B}' |
        '\u{000C}' |
        '\u{0085}' |
        '\u{00A0}' |
        '\u{1680}' |
        '\u{2000}'...'\u{200A}' |
        '\u{2028}' |
        '\u{2029}' |
        '\u{202F}' |
        '\u{205F}' |
        '\u{3000}' => true,
        _ => false,
    }
}
