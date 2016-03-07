use super::*;
use std::marker::PhantomData;
use std::ops::Range;


pub struct TagWriterNotStarted(());
pub struct TagWriterStarted(());

pub struct TagWriter<State> {
    tag: Tag,
    document: Option<DocumentWriter>,
    state: PhantomData<State>,
}

impl TagWriter<TagWriterNotStarted> {
    pub fn new() -> Self {
        TagWriter {
            tag: Tag {
                position: None,
                document: None,
            },
            document: None,
            state: PhantomData,
        }
    }

    pub fn write_document(&mut self, config: &Config, character: char, position: usize) {
        if !config.collects_document {
            return;
        }

        if self.document.is_none() {
            self.document = Option::Some(DocumentWriter { source_map: vec![] });
        }

        if let Option::Some(ref doc) = self.document {
            // TODO
        }
    }

    fn end_document(&mut self, position: usize) {
        if let Option::Some(ref doc) = self.document {
            // TODO
        }
    }

    pub fn start(mut self, config: &Config, position: usize) -> TagWriter<TagWriterStarted> {
        self.end_document(position);

        self.tag.position = if config.collects_position {
            Option::Some(Range {
                start: position - 1,
                end: position,
            })
        } else {
            Option::None
        };

        TagWriter {
            tag: self.tag,
            document: None,
            state: PhantomData,
        }
    }

    pub fn interrupt(mut self, position: usize) -> Tag {
        self.end_document(position);
        self.tag
    }
}

impl TagWriter<TagWriterStarted> {
    pub fn end(mut self, position: usize) -> Tag {
        if let Some(ref mut p) = self.tag.position {
            p.end = position;
        }
        self.tag
    }
}


struct DocumentWriter {
    source_map: Vec<Range<usize>>,
}
