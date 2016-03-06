use super::super::data::*;
use super::*;

use std::ops::Range;
use std::marker::PhantomData;


#[derive(Debug)]
pub struct Error {
    pub data: Option<ArrData<Tag>>,
    pub details: Vec<ErrorDetail>,
}

#[derive(Debug)]
pub struct ErrorDetail {
    pub kind: ErrorKind,
    pub position: Range<i64>,
    pub fatal: bool,
}

impl ErrorDetail {
    pub fn new(kind: ErrorKind, position: Range<i64>, fatal: bool) -> Self {
        ErrorDetail {
            kind: kind,
            position: position,
            fatal: fatal,
        }
    }
}

#[derive(Debug)]
pub enum ErrorKind {
    BlacklistedWhitespace(char),
    InvalidEscapeSequence(String),
    InvalidUnicodeEscape,
    UnclosedArray,
    UnclosedString,
    ExtraClosingBracket,
    TooManyClosingQuotes,
    SeparatorRequired,
}
