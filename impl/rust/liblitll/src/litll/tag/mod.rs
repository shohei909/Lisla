use std::ops::Range;
use std::collections::HashSet;

// ===============================================================================
// Tag
// ===============================================================================

#[derive(Debug, Clone)]
pub struct Tag<TagDetail> {
    pub document: Option<DocumentTag>,
    pub format: Option<FormatTag>,
    pub detail: TagDetail,
}

impl Tag<()> {
    pub fn new() -> Self {
        Tag {
            document: None,
            format: None,
            detail: (),
        }
    }

    pub fn for_string(self, quote: QuoteKind) -> Tag<StringTag> {
        Tag {
            document: self.document,
            format: self.format,
            detail: StringTag {
                position: None,
                escaped: None,
                quote: quote,
            },
        }
    }

    pub fn for_array(self) -> Tag<ArrayTag> {
        Tag {
            document: self.document,
            format: self.format,
            detail: ArrayTag {
                position: None,
                foot_tag: Tag::new(),
            },
        }
    }
}

#[derive(Debug, Clone)]
pub struct StringTag {
    pub position: Option<Range<usize>>,
    pub escaped: Option<HashSet<usize>>,
    pub quote: QuoteKind,
}

#[derive(Debug, Clone)]
pub struct ArrayTag {
    pub position: Option<Range<usize>>,
    pub foot_tag: Tag<()>,
}

#[derive(Debug, Clone, Eq, PartialEq, Copy)]
pub enum QuoteKind {
    Unquoted,
    Quoted(QuoteChar, usize),
}

impl QuoteKind {
    pub fn write_to(&self, output: &mut String) {
        if let QuoteKind::Quoted(ch, count) = *self {
            for _ in 0..count {
                ch.write_to(output);
            }
        }
    }
}

#[derive(Debug, Clone, Eq, PartialEq, Copy)]
pub enum QuoteChar {
    Single,
    Double,
}

impl QuoteChar {
    #[inline]
    pub fn write_to(&self, output: &mut String) {
        let c = match *self {
            QuoteChar::Double => '"',
            QuoteChar::Single => '\'',
        };

        output.push(c);
    }

    pub fn is_match(&self, character: char) -> bool {
        match (*self, character) {
            (QuoteChar::Double, '"') | (QuoteChar::Single, '\'') => true,
            _ => false,
        }
    }
}



// ===============================================================================
// Document
// ===============================================================================

#[derive(Debug, Clone)]
pub struct DocumentTag {
    pub content: String,
    pub source_map: Vec<Range<usize>>,
}

#[derive(Debug, Clone)]
pub struct FormatTag {
    pub has_comma: bool,
    pub has_space: bool,
    pub lines: Vec<Option<UndocumentedComment>>,
    pub document_position: usize,
    pub new_line_summary: NewLineSummary,
}

impl FormatTag {
    pub fn frequent_new_line_char(&self) -> NewLineChar {
        let s = &self.new_line_summary;

        if s.cr >= s.lf && s.cr >= s.cr_lf {
            NewLineChar::Cr
        } else if s.cr_lf >= s.lf {
            NewLineChar::CrLf
        } else {
            NewLineChar::Lf
        }
    }
}

#[derive(Debug, Clone)]
pub struct NewLineSummary {
    cr: usize,
    lf: usize,
    cr_lf: usize,
}

#[derive(Debug, Clone)]
pub struct UndocumentedComment {
    pub keeping: bool,
    pub content: String,
}

#[derive(Debug, Clone, Copy, Eq, PartialEq)]
pub enum NewLineChar {
    Cr,
    Lf,
    CrLf,
}

impl NewLineChar {
    pub fn write_to(self, string: &mut String) {
        match self {
            NewLineChar::Cr => string.push('\r'),
            NewLineChar::Lf => string.push('\n'),
            NewLineChar::CrLf => string.push_str("\r\n"),
        }
    }

    pub fn len(&self) -> usize {
        match *self {
            NewLineChar::Cr | NewLineChar::Lf => 1,
            NewLineChar::CrLf => 2,
        }
    }
}
