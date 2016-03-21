pub mod parse;
pub mod write;
pub mod tag;
pub mod util;

use self::tag::*;

#[derive(Debug, Clone)]
pub struct SoraString {
    pub data: String,
    pub tag: Tag<StringTag>,
}

impl SoraString {
    pub fn new(string: String) -> Self {
        SoraString {
            data: string,
            tag: Tag::new().for_string(QuoteKind::Quoted(QuoteChar::Double, 1)),
        }
    }
}

#[derive(Debug, Clone)]
pub struct SoraArray {
    pub data: Vec<Sora>,
    pub tag: Tag<ArrayTag>,
}

impl SoraArray {
    pub fn new(arr: Vec<Sora>) -> Self {
        SoraArray {
            data: arr,
            tag: Tag::new().for_array(),
        }
    }
}

#[derive(Debug, Clone)]
pub enum Sora {
    String(SoraString),
    Array(SoraArray),
}

impl Sora {
    pub fn str(self) -> Option<String> {
        match self {
            Sora::String(data) => Option::Some(data.data),
            Sora::Array(_) => Option::None,
        }
    }

    pub fn arr(self) -> Option<Vec<Sora>> {
        match self {
            Sora::String(_) => Option::None,
            Sora::Array(data) => Option::Some(data.data),
        }
    }

    pub fn is_str(&self) -> bool {
        match *self {
            Sora::String(_) => true,
            Sora::Array(_) => false,
        }
    }

    pub fn is_arr(&self) -> bool {
        match *self {
            Sora::String(_) => false,
            Sora::Array(_) => true,
        }
    }
}
