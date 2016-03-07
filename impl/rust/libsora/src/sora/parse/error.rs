use super::super::data::*;
use super::*;

use std::ops::Range;


#[derive(Debug)]
pub struct Error {
    pub data: Option<ArrData<Tag>>,
    pub details: Vec<ErrorDetail>,
}

#[derive(Debug)]
pub struct ErrorDetail {
    pub kind: ErrorKind,
    pub position: Range<usize>,
    pub fatal: bool,
}

impl ErrorDetail {
    pub fn new(kind: ErrorKind, position: Range<usize>, fatal: bool) -> Self {
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
    InvalidDigitUnicodeEscape,
    InvalidUnicode,
    InvalidIndent,
    UnclosedArray,
    UnclosedString,
    ExtraClosingBracket,
    TooManyClosingQuotes,
    SeparatorRequired,
}
