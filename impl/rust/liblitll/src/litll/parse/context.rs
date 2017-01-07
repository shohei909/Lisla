use super::super::tag::*;
use super::tag_write::*;

pub enum Context {
    Array(ArrayContext),
    OpeningQuote(QuoteChar,
                 /// length
                 usize),
    QuotedString(QuotedStringContext),
    UnquotedString(UnquotedStringContext),
    Comment(CommentContext),
}

pub enum ArrayContext {
    Normal,
    CarriageReturn,
    NotSeparated,

    Slash(/// length
          usize),
}

pub struct CommentContext {
    pub keeping: bool,
    pub document: bool,
}

pub struct QuotedStringContext {
    pub lines: Vec<(String, Option<NewLineChar>, usize)>,
    pub inline_context: QuotedStringInlineContext,
    pub quote: QuoteChar,
    pub opening_quotes: usize,
    pub start_position: usize,
    pub tag: TagWriter<StringTag>,
}

pub enum QuotedStringInlineContext {
    Indent,
    CarriageReturn,
    Body,
    Quotes(/// length
           usize),
    EscapeSequence(EscapeSequenceContext),
}

pub enum UnquotedStringOperation {
    Continue(UnquotedStringInlineContext),
    End,
}

pub struct UnquotedStringContext {
    pub string: String,
    pub inline_context: UnquotedStringInlineContext,
    pub tag: TagWriter<StringTag>,
}

pub enum UnquotedStringInlineContext {
    Body(/// is slash
         bool),
    EscapeSequence(EscapeSequenceContext),
}

pub enum EscapeSequenceContext {
    Head,
    Unicode(Option<String>),
}

pub enum EscapeSequenceOperation {
    Continue(EscapeSequenceContext),
    End(char),
}
