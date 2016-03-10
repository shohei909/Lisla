pub mod parse;

#[derive(Debug)]
pub enum Sora<Tag> {
    /// 
    String(SoraString<Tag>),
    Array(SoraArray<Tag>),
}

#[derive(Debug)]
pub struct SoraString<Tag> {
    pub data: String,
    pub is_quoted: bool,
    pub tag: Tag,
}

#[derive(Debug)]
pub struct SoraArray<Tag> {
    pub data: Vec<Sora<Tag>>,
    pub tag: Tag,
    pub extra_tag: Tag,
}

impl<Tag> Sora<Tag> {
    pub fn str(self) -> Option<String> {
        match self {
            Sora::String(data) => Option::Some(data.data),
            Sora::Array(_) => Option::None,
        }
    }

    pub fn arr(self) -> Option<Vec<Sora<Tag>>> {
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
