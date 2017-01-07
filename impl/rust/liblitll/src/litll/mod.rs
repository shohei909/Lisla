pub mod parse;
pub mod write;
pub mod tag;
pub mod util;

use self::tag::*;

#[derive(Debug, Clone)]
pub struct LitllString {
    pub data: String,
    pub tag: Tag<StringTag>,
}

impl LitllString {
    pub fn new(string: String) -> Self {
        LitllString {
            data: string,
            tag: Tag::new().for_string(QuoteKind::Quoted(QuoteChar::Double, 1)),
        }
    }
}

#[derive(Debug, Clone)]
pub struct LitllArray {
    pub data: Vec<Litll>,
    pub tag: Tag<ArrayTag>,
}

impl LitllArray {
    pub fn new(arr: Vec<Litll>) -> Self {
        LitllArray {
            data: arr,
            tag: Tag::new().for_array(),
        }
    }
}

#[derive(Debug, Clone)]
pub enum Litll {
    String(LitllString),
    Array(LitllArray),
}

impl Litll {
    pub fn str(self) -> Option<String> {
        match self {
            Litll::String(data) => Option::Some(data.data),
            Litll::Array(_) => Option::None,
        }
    }

    pub fn arr(self) -> Option<Vec<Litll>> {
        match self {
            Litll::String(_) => Option::None,
            Litll::Array(data) => Option::Some(data.data),
        }
    }

    pub fn is_str(&self) -> bool {
        match *self {
            Litll::String(_) => true,
            Litll::Array(_) => false,
        }
    }

    pub fn is_arr(&self) -> bool {
        match *self {
            Litll::String(_) => false,
            Litll::Array(_) => true,
        }
    }
}
