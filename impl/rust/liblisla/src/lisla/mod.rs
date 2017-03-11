pub mod parse;
pub mod write;
pub mod tag;
pub mod util;

use self::tag::*;

#[derive(Debug, Clone)]
pub struct LislaString {
    pub data: String,
    pub tag: Tag<StringTag>,
}

impl LislaString {
    pub fn new(string: String) -> Self {
        LislaString {
            data: string,
            tag: Tag::new().for_string(QuoteKind::Quoted(QuoteChar::Double, 1)),
        }
    }
}

#[derive(Debug, Clone)]
pub struct LislaArray {
    pub data: Vec<Lisla>,
    pub tag: Tag<ArrayTag>,
}

impl LislaArray {
    pub fn new(arr: Vec<Lisla>) -> Self {
        LislaArray {
            data: arr,
            tag: Tag::new().for_array(),
        }
    }
}

#[derive(Debug, Clone)]
pub enum Lisla {
    String(LislaString),
    Array(LislaArray),
}

impl Lisla {
    pub fn str(self) -> Option<String> {
        match self {
            Lisla::String(data) => Option::Some(data.data),
            Lisla::Array(_) => Option::None,
        }
    }

    pub fn arr(self) -> Option<Vec<Lisla>> {
        match self {
            Lisla::String(_) => Option::None,
            Lisla::Array(data) => Option::Some(data.data),
        }
    }

    pub fn is_str(&self) -> bool {
        match *self {
            Lisla::String(_) => true,
            Lisla::Array(_) => false,
        }
    }

    pub fn is_arr(&self) -> bool {
        match *self {
            Lisla::String(_) => false,
            Lisla::Array(_) => true,
        }
    }
}
