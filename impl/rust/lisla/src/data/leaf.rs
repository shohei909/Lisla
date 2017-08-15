use std::fmt::Debug;
use data::tag::*;
use std::hash::{Hash, Hasher};
use std::cmp::Eq;

#[derive(Debug, Clone)]
pub struct Leaf<LeafType: Debug + Clone> { 
    pub leaf: LeafType,
    pub tag: Tag,
}

#[derive(Debug, Clone)]
pub struct LabelLeaf {
    pub string: String,
    pub tag: Tag,
}

impl Hash for LabelLeaf {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.string.hash(state)
    }
}

impl PartialEq for LabelLeaf {
    fn eq(&self, other: &LabelLeaf) -> bool {
        self.string == other.string
    }
}

impl Eq for LabelLeaf {}