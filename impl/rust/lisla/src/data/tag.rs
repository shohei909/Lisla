use data::position::*;
use data::tree::*;
use std::cell::RefCell;
use parse::error::ParseStringError;
use macros;
use std::fmt::Debug;

#[derive(Debug, Clone)]
pub struct Tag {
    pub content_range: Range,
    pub leading_space: Option<Space>,
    pub kind: Option<TagKind>,

    document:RefCell<DocumentState>,
    // type:RefCell<_>,
}

impl Tag {
    pub fn new(leading_space:Option<Space>, content_range:Range, tag_kind:Option<TagKind>) -> Tag {
        Tag {
            leading_space,
            content_range,
            document: RefCell::new(DocumentState::None),
            kind: tag_kind
        }
    }
}

#[derive(Debug, Clone)]
pub enum TagKind {
    Leaf(LeafTag),
    Array(ArrayTag),
}

#[derive(Debug, Clone)]
pub struct LeafTag {
    pub quote: Option<Quote>,
    pub raw_content: String,
}

#[derive(Debug, Clone)]
pub struct ArrayTag {
    pub footer_space: Option<Space>,
}


#[derive(Debug, Clone)]
pub enum DocumentState {
    None,
    Parsed(Result<Box<ATreeArrayBranch<String>>, ParseStringError>),
}

#[derive(Debug, Clone)]
pub struct Space {
    pub range: Range,
    pub lines: Vec<SpaceLine>,
}

impl Space {
    pub fn add_indent(&mut self, character:char) {
        if let Option::Some(mut line) = self.lines.last_mut() {
            line.indent.push(character);
        }
    }
}

#[derive(Debug, Clone)]
pub struct SpaceLine {
    pub range:Range,
    pub indent:String,
    pub comment:Option<Comment>,
    pub newline:Option<NewlineKind>,
}

#[derive(Debug, Clone)]
pub struct Comment {
    pub keeping:bool,
    pub is_document:bool,
    pub content:String,
}

impl Comment {
    pub fn new() -> Comment {
        Comment {
            keeping: false,
            is_document: false,
            content: String::new()
        }
    }
}

#[derive(Debug, Clone)]
pub struct Quote {
    pub kind: QuoteKind,
    pub count: usize,
}

#[derive(Debug, Clone, Copy)]
pub enum NewlineKind {
    CrLf,
    Lf,
    Cr,
}

#[derive(Debug, Clone, Copy)]
pub enum QuoteKind {
    Single,
    Double,
}

impl QuoteKind {
    pub fn character(&self) -> char {
        match self {
            Single => '\'',
            Double => '\"',
        }
    }
}
