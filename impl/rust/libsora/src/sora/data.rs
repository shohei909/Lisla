#[derive(Debug)]
pub enum StrOrArr<Tag> {
    /// 
    Str(StrData<Tag>),
    Arr(ArrData<Tag>),
}

#[derive(Debug)]
pub struct StrData<Tag> {
    pub data: String,
    pub is_quoted: bool,
    pub tag: Tag,
}

#[derive(Debug)]
pub struct ArrData<Tag> {
    pub data: Vec<StrOrArr<Tag>>,
    pub tag: Tag,
    pub extra_tag: Tag,
}

impl<Tag> StrOrArr<Tag> {
    pub fn str(self) -> Option<String> {
        match self {
            StrOrArr::Str(data) => Option::Some(data.data),
            StrOrArr::Arr(_) => Option::None,
        }
    }

    pub fn arr(self) -> Option<Vec<StrOrArr<Tag>>> {
        match self {
            StrOrArr::Str(_) => Option::None,
            StrOrArr::Arr(data) => Option::Some(data.data),
        }
    }

    pub fn is_str(&self) -> bool {
        match *self {
            StrOrArr::Str(_) => true,
            StrOrArr::Arr(_) => false,
        }
    }

    pub fn is_arr(&self) -> bool {
        match *self {
            StrOrArr::Str(_) => false,
            StrOrArr::Arr(_) => true,
        }
    }
}
