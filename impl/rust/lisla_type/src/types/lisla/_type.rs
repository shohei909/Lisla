use ::arraytree_lang::tag::*;
use ::arraytree_lang::tree::*;
use ::types::core::*;
use ::arraytree_lang::leaf::*;
use ::arraytree_lang::from::error::*;
use ::arraytree_core::error::*;

#[derive(LislaNewtype)]
#[derive(Debug, Clone)]
pub struct TypeArgument {
    pub value: ArrayTree<StringLeaf>
}

#[derive(LislaNewtype)]
#[derive(Debug, Clone)]
pub struct TypePath {
    pub value: StringLeaf,
}

#[derive(LislaNewtype)]
#[derive(Debug, Clone)]
pub struct TypeName {
    pub value: StringLeaf,
}

#[derive(LislaUnion)]
#[derive(Debug, Clone)]
pub enum TypeReferece {
    Primitive(TypePath),
    Generic(GenericTypeReferece),
}

#[derive(LislaTuple)]
#[derive(Debug, Clone)]
pub struct GenericTypeReferece {
    pub name: WithTag<TypePath>,
    #[arraytree(spreads_rest)]
    pub arguments: WithTag<ArrayBranch<WithTag<TypeArgument>>>,
}

#[derive(LislaTuple)]
#[derive(Debug, Clone)]
pub struct TypeTypeParameterDeclaration {
    #[arraytree(label = "type")]
    pub label0 : WithTag<Const>,
    pub name : WithTag<TypeName>,
}
