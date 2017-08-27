use ::lisla_lang::tag::*;
use ::lisla_lang::tree::*;
use ::types::core::*;
use ::lisla_lang::leaf::*;
use ::lisla_lang::from::error::*;
use ::lisla_core::error::*;


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

#[derive(LislaNewtype)]
#[derive(Debug, Clone)]
pub struct TypeArgument {
    pub value: ArrayTree<StringLeaf>
}

#[derive(LislaUnion)]
#[derive(Debug, Clone)]
pub enum TypeReferece {
    Primitive(TypePath),
    Generic(GenericTypeReferece),
}

impl TypeReference {
    pub fn from_array_tree {
    }

    pub fn from_array_tree_array {
    }

    pub fn from_array_tree_array {
    }
}

#[derive(LislaTuple)]
#[derive(Debug, Clone)]
pub struct GenericTypeReferece {
    pub name: WithTag<TypePath>,
    #[lisla(spreads_rest)]
    pub arguments: WithTag<ArrayBranch<WithTag<TypeArgument>>>,
}

#[derive(LislaTuple)]
#[derive(Debug, Clone)]
pub struct TypeTypeParameterDeclaration {
    #[lisla(label = "type")]
    pub label0 : WithTag<Const>,
    pub name : WithTag<TypeName>,
}
