use super::*;
use super::tag::*;
use std::collections::HashSet;


// ===============================================================================
// Config
// ===============================================================================

#[derive(Clone, Debug)]
pub struct Config {
    pub line_mode: LineMode,
    pub new_line_char: (NewLineChar, Flexibility),
    pub separation_mode: SeparationMode,
    pub indent: IndentMode,
    pub string_mode: StringMode,
}

#[derive(Clone, Debug)]
pub enum StringMode {
    Minified,
    Pretty,
    JsonCompatible,
}

#[derive(Clone, Debug)]
pub enum SeparationMode {
    Minified(CommaOrSpace),
    Pretty(PrettySeparationMode, Flexibility),
}

#[derive(Clone, Debug)]
pub enum LineMode {
    Remain,
    Remove {
        comment: CommentMode,
    },
}

#[derive(Clone, Debug, Copy, Eq, PartialEq)]
pub enum Flexibility {
    Flex,
    Rigid,
}

#[derive(Clone, Debug)]
pub struct CommentMode {
    pub remove_document: bool,
    pub remove_keeping: bool,
}

#[derive(Clone, Debug)]
pub enum IndentMode {
    Space(u32),
    Tab,
}

#[derive(Clone, Debug, Copy, Eq, PartialEq)]
pub enum PrettySeparationMode {
    Comma(Option<SpaceOrNewLine>, Flexibility),
    NonComma(SpaceOrNewLine, Flexibility),
}

#[derive(Clone, Debug, Copy, Eq, PartialEq)]
pub enum SpaceOrNewLine {
    Space,
    NewLineChar,
}

#[derive(Clone, Debug, Copy, Eq, PartialEq)]
pub enum CommaOrSpace {
    Comma,
    Space,
}

impl Config {
    #[inline]
    pub fn minified() -> Self {
        Config {
            new_line_char: (NewLineChar::Lf, Flexibility::Rigid),
            indent: IndentMode::Space(0),
            line_mode: LineMode::Remove {
                comment: CommentMode {
                    remove_keeping: false,
                    remove_document: true,
                },
            },
            separation_mode: SeparationMode::Minified(CommaOrSpace::Space),
            string_mode: StringMode::Minified,
        }
    }

    #[inline]
    pub fn pretty() -> Self {
        Config {
            new_line_char: (NewLineChar::Lf, Flexibility::Flex),
            indent: IndentMode::Space(4),
            line_mode: LineMode::Remain,
            separation_mode: SeparationMode::Pretty(PrettySeparationMode::Comma(Option::Some(SpaceOrNewLine::NewLineChar), Flexibility::Flex), Flexibility::Flex), 
            string_mode: StringMode::Pretty,
        }
    }

    #[inline]
    pub fn json_compatible(minify: bool) -> Self {
        let flexibility = if minify {
            Flexibility::Rigid
        } else {
            Flexibility::Flex
        };
        let indent = if minify {
            0
        } else {
            4
        };
        let separation_mode = if minify {
            SeparationMode::Pretty(PrettySeparationMode::Comma(Option::None, Flexibility::Rigid),
                                   Flexibility::Rigid)
        } else {
            SeparationMode::Pretty(PrettySeparationMode::Comma(Option::Some(SpaceOrNewLine::Space),
                                                               Flexibility::Flex),
                                   Flexibility::Rigid)
        };

        Config {
            new_line_char: (NewLineChar::Lf, flexibility),
            indent: IndentMode::Space(indent),
            line_mode: LineMode::Remove {
                comment: CommentMode {
                    remove_document: true,
                    remove_keeping: true,
                },
            },
            separation_mode: separation_mode,
            string_mode: StringMode::JsonCompatible,
        }
    }
}


// ===============================================================================
// Writer Struct
// ===============================================================================

struct Writer<'a> {
    config: &'a Config,
    depth: usize,
    new_line_char: NewLineChar,
}


// ===============================================================================
// Context
// ===============================================================================

struct ArrayContext {
    has_new_line: bool,
    end_with_new_line: bool,
}

#[derive(Eq, PartialEq, Clone, Copy)]
enum SeparationContext {
    Head,
    Body(// is_separater_required
         bool),
    Foot(// has_new_line
         bool),
}


// ===============================================================================
// Writer Implements
// ===============================================================================

pub fn write(config: &Config, arr: &LitllArray) -> String {
    let mut output = String::new();
    let mut writer = Writer::new(config, &arr.tag.format);
    writer.write_elements(&mut output, arr);
    return output;
}

impl<'a> Writer<'a> {
    fn new(config: &'a Config, tag: &Option<FormatTag>) -> Self {
        Writer {
            new_line_char: match (tag, config.new_line_char) {
                (&Option::Some(ref t), (_, Flexibility::Flex)) => t.frequent_new_line_char(),
                (&Option::None, (c, Flexibility::Flex)) | (_, (c, Flexibility::Rigid)) => c,
            },
            config: config,
            depth: 0,
        }
    }


    #[inline]
    fn write_elements(&mut self, output: &mut String, arr: &LitllArray) -> ArrayContext {
        let mut iter = arr.data.iter();
        let mut separation = SeparationContext::Head;
        let mut has_new_line = false;
        let mut next = iter.next();

        while let Option::Some(litll) = next {
            match *litll {
                Litll::Array(ref child_arr) => {
                    let separater_has_new_line = self.write_separater(output,
                                                                      &child_arr.tag.format,
                                                                      separation);
                    has_new_line = has_new_line || separater_has_new_line;
                    if separater_has_new_line {
                        self.write_indent(output);
                    }
                    output.push('[');
                    self.depth += 1;
                    let context = self.write_elements(output, &child_arr);
                    has_new_line = context.has_new_line || has_new_line;
                    self.depth -= 1;
                    if context.end_with_new_line {
                        self.write_indent(output);
                    }
                    output.push(']');
                }

                Litll::String(ref string) => {
                    let separater_has_new_line = self.write_separater(output,
                                                                      &string.tag.format,
                                                                      separation);
                    has_new_line = has_new_line || separater_has_new_line;
                    if separater_has_new_line {
                        self.write_indent(output);
                    }

                    self.write_string(output, &string);
                }
            }

            next = iter.next();
            let separater_required = match (litll, next) {
                (&Litll::Array(_), _) | (_, Option::Some(&Litll::Array(_))) => false, 
                _ => true,
            };
            separation = SeparationContext::Body(separater_required);
        }

        let end_with_new_line = self.write_separater(output,
                                                     &arr.tag.detail.foot_tag.format,
                                                     SeparationContext::Foot(has_new_line));

        has_new_line = end_with_new_line || has_new_line;

        ArrayContext {
            has_new_line: has_new_line,
            end_with_new_line: end_with_new_line,
        }
    }

    #[inline]
    fn write_separater(&mut self,
                       output: &mut String,
                       tag: &Option<FormatTag>,
                       context: SeparationContext)
                       -> bool {

        let has_comma = tag.as_ref().map(|t| t.has_comma);
        let maybe_lines = tag.as_ref().map(|t| &t.lines);
        let has_new_line = maybe_lines.as_ref().map(|ls| ls.len() > 0);

        let mut is_new_line_added = false;
        let mut is_separater_required = context == SeparationContext::Body(true);

        let lines = self.resolve_lines(maybe_lines);
        if lines.len() > 0 {
            is_new_line_added = true;
            is_separater_required = false;
        }

        let add_comma = self.resolve_comma(has_comma, is_separater_required, context);
        if add_comma {
            output.push(',');
            is_separater_required = false;
        }

        let mut first_line = true;
        for line in lines.iter() {
            if !first_line {
                self.write_indent(output);
            }
            output.push_str(line.as_str());
            self.write_new_line(output);
            first_line = false;
        }

        let space_or_new_line = self.resolve_space_or_new_line(is_separater_required,
                                                               is_new_line_added,
                                                               has_comma,
                                                               has_new_line,
                                                               context);

        match space_or_new_line {
            Option::None => {}
            Option::Some(SpaceOrNewLine::Space) => output.push(' '),
            Option::Some(SpaceOrNewLine::NewLineChar) => {
                is_new_line_added = true;
                self.write_new_line(output);
            }
        }

        return is_new_line_added;
    }


    #[inline]
    fn resolve_comma(&self,
                     has_comma: Option<bool>,
                     is_separater_required: bool,
                     context: SeparationContext)
                     -> bool {

        let (pretty_mode, comma_flexybility) = match &self.config.separation_mode {
            &SeparationMode::Minified(CommaOrSpace::Comma) => return is_separater_required,
            &SeparationMode::Minified(CommaOrSpace::Space) => return false,
            &SeparationMode::Pretty(m, f) => (m, f),
        };

        let mut is_comma_mode = match pretty_mode {
            PrettySeparationMode::Comma(..) => true,
            PrettySeparationMode::NonComma(..) => false,
        };

        match context {
            SeparationContext::Head => {
                return false;
            }
            SeparationContext::Foot(_) => {
                is_comma_mode = false;
            }
            SeparationContext::Body(_) => {}
        }

        if let Flexibility::Rigid = comma_flexybility {
            return is_comma_mode;
        }

        has_comma.unwrap_or(is_comma_mode)
    }


    #[inline]
    fn resolve_lines(&mut self, lines: Option<&Vec<Option<UndocumentedComment>>>) -> Vec<String> {
        let mut out_lines = vec![];

        if let Option::Some(lines) = lines {
            for line in lines.iter() {
                match (line, &self.config.line_mode) {
                    (&Option::None, &LineMode::Remain) => {
                        out_lines.push(String::new());
                    }

                    (&Option::Some(UndocumentedComment { keeping: true, ref content }),
                    &LineMode::Remain) |
                    (&Option::Some(UndocumentedComment { keeping: true, ref content }),
                    &LineMode::Remove{comment: CommentMode { remove_keeping: false, remove_document: _ }}) => {
                        out_lines.push(["//!".to_owned(), content.clone()].concat());
                    }

                    (&Option::Some(UndocumentedComment { keeping: false, ref content}),
                     &LineMode::Remain) => {
                        out_lines.push(["//".to_owned(), content.clone()].concat());
                    }

                    (_, _) => {}
                }
            }
        }

        out_lines
    }

    fn resolve_space_or_new_line(&self,
                                 is_separater_required: bool,
                                 is_new_line_added: bool,
                                 has_space: Option<bool>,
                                 has_new_line: Option<bool>,
                                 context: SeparationContext)
                                 -> Option<SpaceOrNewLine> {
        if is_new_line_added {
            return Option::None;
        }

        let pretty_mode = match self.config.separation_mode {
            SeparationMode::Minified(comma_or_space) => {
                return if comma_or_space == CommaOrSpace::Space && is_separater_required {
                    Option::Some(SpaceOrNewLine::Space)
                } else {
                    Option::None
                }
            }

            SeparationMode::Pretty(m, _) => m,
        };

        let (mut space_or_new_line, flexibility) = match pretty_mode {
            PrettySeparationMode::Comma(s, f) => (s, f),
            PrettySeparationMode::NonComma(s, f) => (Option::Some(s), f),
        };

        match context {
            SeparationContext::Foot(new_line_context) => {
                space_or_new_line = if self.depth == 0 {
                    Option::None
                } else if new_line_context {
                    Option::Some(SpaceOrNewLine::NewLineChar)
                } else {
                    Option::None
                }
            }

            SeparationContext::Head => {
                if self.depth == 0 {
                    space_or_new_line = Option::None;
                } else if let Option::Some(SpaceOrNewLine::Space) = space_or_new_line {
                    space_or_new_line = Option::None;
                }
            }

            SeparationContext::Body(_) => {}
        }

        if flexibility == Flexibility::Rigid {
            return space_or_new_line;
        }

        match (has_new_line, has_space, is_separater_required) {
            (Option::Some(true), _, _) => Option::Some(SpaceOrNewLine::NewLineChar),
            (_, Option::Some(true), _) => Option::Some(SpaceOrNewLine::Space),
            (Option::Some(false), Option::Some(false), false) => Option::None,
            (_, _, false) => space_or_new_line,
            (_, _, true) => Option::Some(space_or_new_line.unwrap_or(SpaceOrNewLine::Space)),
        }
    }

    fn write_indent(&mut self, output: &mut String) {
        for _ in 0..self.depth {
            match self.config.indent {
                IndentMode::Space(n) => {
                    for _ in 0..n {
                        output.push(' ');
                    }
                }
                IndentMode::Tab => {
                    output.push('\t');
                }
            }
        }
    }

    fn write_new_line(&mut self, output: &mut String) {
        self.new_line_char.write_to(output);
    }


    #[inline]
    fn write_string(&mut self, output: &mut String, litll_string: &LitllString) -> bool {
        let mut quote = litll_string.tag.detail.quote;
        let mut starts_with_new_line = false;
        let mut force_escape = false;
        let mut longest_quotes = 0;
        let mut starts_with_lf = false;
        let mut end_with_cr = false;
        let escaped_tag = &litll_string.tag.detail.escaped;

        match self.config.string_mode {
            StringMode::Minified => {
                if let QuoteKind::Quoted(_, _) = quote {
                    quote = QuoteKind::Quoted(QuoteChar::Double, 1);
                    force_escape = true;
                }
            }
            StringMode::JsonCompatible => {
                quote = QuoteKind::Quoted(QuoteChar::Double, 1);
                force_escape = true;
            }
            StringMode::Pretty => {
                let mut i = 0;
                let mut quotes_counter = 0;
                let len = litll_string.data.len();
                if let QuoteKind::Quoted(quote_char, _) = quote {
                    for character in litll_string.data.chars() {
                        match (quote_char, character) {
                            (_, '\n') | (_, '\r') => {
                                if !is_escaped_in_quoted(quote_char, character, escaped_tag, i) {
                                    starts_with_new_line = true;
                                    if i == 0 && character == '\n' {
                                        starts_with_lf = true;
                                    }
                                    if i + 1 == len && character == '\r' {
                                        end_with_cr = true;
                                    }
                                }
                                quotes_counter = 0;
                            }

                            _ => {
                                if quote_char.is_match(character) {
                                    if i == 0 {
                                        starts_with_new_line = true;
                                    }
                                    quotes_counter += 1;
                                    if quotes_counter > longest_quotes {
                                        longest_quotes = quotes_counter;
                                    }
                                } else {
                                    quotes_counter = 0;
                                }
                            }
                        }
                        i += 1;
                    }
                }
            }
        }

        if let QuoteKind::Quoted(_, ref mut count) = quote {
            if *count <= longest_quotes {
                *count = longest_quotes + 1;
            }
            if *count == 2 {
                *count = 3;
            }
        }

        if litll_string.data.len() == 0 {
            let quote_char = match quote {
                QuoteKind::Quoted(c, _) => c,
                QuoteKind::Unquoted => QuoteChar::Double,
            };
            quote = QuoteKind::Quoted(quote_char, 1);
        }

        quote.write_to(output);
        let mut has_new_line = false;
        let mut on_new_line = false;
        let mut line_starts_with_space = false;

        if starts_with_new_line {
            let mut new_line_char = self.new_line_char;
            if new_line_char == NewLineChar::Cr && starts_with_lf {
                new_line_char = NewLineChar::Lf;
            }
            new_line_char.write_to(output);
            on_new_line = true;
            has_new_line = true;
        }

        let mut prev_character = Option::None;
        let mut i = 0;
        for character in litll_string.data.chars() {
            let escaped = is_escaped(quote,
                                     force_escape,
                                     prev_character,
                                     character,
                                     escaped_tag,
                                     i);
            if escaped {
                if on_new_line {
                    self.write_indent(output);
                    on_new_line = false;
                    line_starts_with_space = false;
                }
                write_escaped(output, character);
            } else {
                match character {
                    '\n' | '\r' => {
                        output.push(character);
                        on_new_line = true;
                        has_new_line = true;
                    }

                    _ => {
                        if on_new_line {
                            self.write_indent(output);
                            on_new_line = false;
                            line_starts_with_space = util::is_whitespace(character);
                        }

                        output.push(character);
                    }
                }
            }

            prev_character = Option::Some((character, escaped));
            i += 1;
        }

        if let QuoteKind::Quoted(quote_char, _) = quote {
            let ends_with_quote = if let Option::Some((c, false)) = prev_character {
                quote_char.is_match(c)
            } else {
                false
            };

            if starts_with_new_line || line_starts_with_space || ends_with_quote {
                let mut new_line_char = self.new_line_char;
                if new_line_char == NewLineChar::Lf && end_with_cr {
                    new_line_char = NewLineChar::Cr;
                }
                new_line_char.write_to(output);
                on_new_line = true;
            }
        }

        if on_new_line {
            self.write_indent(output);
        }
        quote.write_to(output);

        has_new_line
    }
}

#[inline]
fn is_escaped(quote: QuoteKind,
              force_escape: bool,
              prev_charcter: Option<(char, bool)>,
              character: char,
              escaped: &Option<HashSet<usize>>,
              i: usize)
              -> bool {
    match quote {
        QuoteKind::Quoted(quote_char, _) => {
            if force_escape {
                match character {
                    '\n' | '\r' | '\"' => {
                        return true;
                    }
                    _ => {}
                }
            }

            is_escaped_in_quoted(quote_char, character, escaped, i)
        }

        QuoteKind::Unquoted => {
            if let Option::Some(ref escaped_set) = *escaped {
                if escaped_set.contains(&i) {
                    return true;
                }
            }

            if util::is_blacklisted_whitespace(character) {
                return true;
            }

            match character {
                '\n' | '\r' | '[' | ']' | ',' | ' ' | '\t' | '\'' | '\"' | '\\' => true,
                '/' if prev_charcter == Option::Some(('/', false)) => true,
                _ => false,
            }
        }
    }
}

#[inline]
fn is_escaped_in_quoted(quote_char: QuoteChar,
                        character: char,
                        escaped: &Option<HashSet<usize>>,
                        i: usize)
                        -> bool {
    if quote_char == QuoteChar::Double {
        match character {
            '\\' => {
                return true;
            }
            _ => {}
        }
        if let Option::Some(ref escaped_set) = *escaped {
            if escaped_set.contains(&i) {
                return true;
            }
        }
    }
    false
}

#[inline]
fn write_escaped(output: &mut String, character: char) {
    let s = match character {
        '\r' => "\\r",
        '\n' => "\\n",
        '\t' => "\\t",
        '\\' => "\\\\",
        '\0' => "\\0",
        '\'' => "\\'",
        '"' => "\\\"",
        _ => {
            let f = format!("\\u{{{:X}}}", character as u32);
            output.push_str(f.as_str());
            return;
        }
    };

    output.push_str(s);
}
