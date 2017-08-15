
use linked_hash_map::LinkedHashMap;
use std::marker::Sized;
use data::tag::*;
use data::leaf::*;
use std::fmt::Debug;

#[derive(Debug, Clone)]
pub enum ATree<LeafType:Debug + Clone> {
    Array(ATreeArrayBranch<LeafType>),
    Leaf(Leaf<LeafType>),
}

#[derive(Debug, Clone)]
pub struct ArrayBranch<TreeType:Debug + Clone> {
    pub array: Vec<TreeType>,
    pub tag: Tag,
}

#[derive(Debug, Clone)]
pub enum AseTree<LeafType:Debug + Clone> {
    Array(AseTreeArrayBranch<LeafType>),
    Struct(AseTreeStructBranch<LeafTag>),
    Enum(AseTreeEnumBranch<LeafTag>),
    Leaf(LeafType),
}

#[derive(Debug, Clone)]
pub struct StructBranch<TreeType> {
    pub map: LinkedHashMap<LabelLeaf, TreeType>,
    pub tag: Tag,
}

#[derive(Debug, Clone)]
pub struct EnumBranch<TreeType:Debug + Clone> {
    pub label: LabelLeaf, 
    pub parameters: Vec<TreeType>,
    pub tag: Tag,
}

pub trait Tree<LeafType> {}
impl<LeafType:Debug + Clone> Tree<LeafType> for ATree<LeafType> {}
impl<LeafType:Debug + Clone> Tree<LeafType> for AseTree<LeafType> {}

pub type ATreeArrayBranch<T> = ArrayBranch<ATree<T>>;
pub type AseTreeArrayBranch<T> = ArrayBranch<AseTree<T>>;
pub type AseTreeEnumBranch<T> = EnumBranch<AseTree<T>>;
pub type AseTreeStructBranch<T> = StructBranch<AseTree<T>>;