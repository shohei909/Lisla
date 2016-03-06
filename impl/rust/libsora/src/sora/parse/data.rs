use super::super::data::*;
use super::tag::*;
use super::*;

use std::ops::Range;

pub type OutputArray = (Vec<StrOrArr<Tag>>, TagWriter<TagWriterStarted>);

pub enum Context {
    Array(ArrayContext),
    OpeningQuote(char, i64),
    QuotedString(QuotedStringContext),
    UnquotedString(UnquotedStringContext),
    Comment(CommentContext),
}

pub enum ArrayContext {
    Normal,

    NotSeparated,

    // (length)
    Slash(i32),
}

pub struct CommentContext {
    pub keeping: bool,
    pub document: bool,
}

pub struct QuotedStringContext {
    pub lines: Vec<(String, i64)>,
    pub inline_context: QuotedStringInlineContext,
    pub quote: char,
    pub opening_quotes: i64,
    pub tag: TagWriter<TagWriterStarted>,
}

pub enum QuotedStringInlineContext {
    Indent,
    Body,
    Quotes(i64),
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
