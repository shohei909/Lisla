
use tag::*;
use tree::leaf::*;
use std::fmt::Debug;

pub mod leaf;

#[derive(Debug, Clone)]
pub enum ATree<LeafType:Debug + Clone> {
    Array(ATreeArrayBranch<LeafType>),
    Leaf(Leaf<LeafType>),
}

impl<LeafType:Debug + Clone> ATree<LeafType> {
    pub fn to_branch(self) -> Option<ATreeArrayBranch<LeafType>> {
        match self {
            ATree::Array(branch) => Option::Some(branch),
            ATree::Leaf(_) => Option::None,
        }
    }
    pub fn to_leaf(self) -> Option<Leaf<LeafType>> {
        match self {
            ATree::Array(_) => Option::None,
            ATree::Leaf(leaf) => Option::Some(leaf),
        }
    }
}


#[derive(Debug, Clone)]
pub struct ArrayBranch<TreeType:Debug + Clone> {
    pub array: Vec<TreeType>,
    pub tag: Tag,
}

pub trait Tree<LeafType> {}
impl<LeafType:Debug + Clone> Tree<LeafType> for ATree<LeafType> {}

pub type ATreeArrayBranch<T> = ArrayBranch<ATree<T>>;
