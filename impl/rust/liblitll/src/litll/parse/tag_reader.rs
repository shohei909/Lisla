use super::*;
use std::ops::Range;
use std::mem::replace;
use super::super::tag::*;

pub struct TagReader<State> {
    tag: Tag<State>,
}

impl TagReader<StringTag> {
    pub fn end(mut self, position: usize) -> Tag<StringTag> {
        if let Some(ref mut p) = self.tag.detail.position {
            p.end = position;
        }
        self.tag
    }
}

impl TagReader<ArrayTag> {
    pub fn new() -> Self {
        TagReader { tag: Tag::new().for_array() }
    }

    pub fn write_document(&mut self, config: &Config, character: char, position: usize) {
        if !config.collects_document {
            return;
        }

        // TODO
    }

    fn end_document(&mut self, position: usize) {
        // TODO
    }

    fn start(&mut self, config: &Config, position: usize) -> Option<Range<usize>> {
        self.end_document(position);

        if config.collects_position {
            Option::Some(Range {
                start: position - 1,
                end: position,
            })
        } else {
            Option::None
        }
    }

    pub fn pop_for_string(&mut self,
                          config: &Config,
                          position: usize,
                          quote: QuoteKind)
                          -> TagReader<StringTag> {
        let foot_tag = replace(&mut self.tag.detail.foot_tag, Tag::new());
        let mut tag = foot_tag.for_string(quote);
        tag.detail.position = self.start(config, position);

        TagReader { tag: tag }
    }

    pub fn pop_for_array(&mut self, config: &Config, position: usize) -> TagReader<ArrayTag> {
        let foot_tag = replace(&mut self.tag.detail.foot_tag, Tag::new());
        let mut tag = foot_tag.for_array();
        tag.detail.position = self.start(config, position);

        TagReader { tag: tag }
    }

    pub fn end(mut self, position: usize) -> Tag<ArrayTag> {
        self.end_document(position);
        if let Some(ref mut p) = self.tag.detail.position {
            p.end = position;
        }
        self.tag
    }
}
