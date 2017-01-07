use super::super::*;
use std::ops::Range;


#[derive(Debug)]
pub struct Error {
    pub data: Option<LitllArray>,
    pub entries: Vec<ErrorEntry>,
}

#[derive(Debug)]
pub struct ErrorEntry {
    pub kind: ErrorKind,
    pub position: Range<usize>,
    pub fatal: bool,
}

impl ErrorEntry {
    pub fn new(kind: ErrorKind, position: Range<usize>, fatal: bool) -> Self {
        ErrorEntry {
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
