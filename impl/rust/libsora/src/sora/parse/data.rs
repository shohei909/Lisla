use super::super::data::*;
use super::tag::*;
use super::*;

pub type OutputArray = (Vec<StrOrArr<Tag>>, TagWriter<TagWriterStarted>);

pub enum Context {
    Array(ArrayContext),
    OpeningQuote(char, usize),
    QuotedString(QuotedStringContext),
    UnquotedString(UnquotedStringContext),
    Comment(CommentContext),
}

pub enum ArrayContext {
    Normal,

    NotSeparated,

    // (length)
    Slash(usize),
}

pub struct CommentContext {
    pub keeping: bool,
    pub document: bool,
}

pub struct QuotedStringContext {
    pub lines: Vec<(String, usize)>,
    pub inline_context: QuotedStringInlineContext,
    pub quote: char,
    pub opening_quotes: usize,
    pub start_position: usize,
    pub tag: TagWriter<TagWriterStarted>,
}

pub enum QuotedStringInlineContext {
    Indent,
    Body,
    Quotes(usize),
    EscapeSequence(EscapeSequenceContext),
}

pub enum UnquotedStringOperation {
    Continue(UnquotedStringInlineContext),
    End,
}

pub struct UnquotedStringContext {
    pub string: String,
    pub inline_context: UnquotedStringInlineContext,
    pub tag: TagWriter<TagWriterStarted>,
}

pub enum UnquotedStringInlineContext {
    // (is slash)
    Body(bool),
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
