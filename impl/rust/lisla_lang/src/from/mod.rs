use tree::ArrayTree;
use from::error::*;
use tree::*;
use leaf::*;
use tag::*;
use std::fmt::Debug;
use ::error::*;
pub mod error;

pub trait FromArrayTree : Sized + Clone + Debug {
    type Parameters : Clone + Debug;

    fn from_array_tree(
        config:&FromArrayTreeConfig,
        tree:WithTag<ArrayTree<StringLeaf>>,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> Result<WithTag<Self>, ()> {
        return match tree.data {
            ArrayTree::Array(array) => {
                Self::from_array_tree_array(
                    config,
                    array,
                    tree.tag,
                    parameters,
                    errors
                )
            }
            ArrayTree::Leaf(string) => {
                Self::from_array_tree_string(
                    config,
                    string,
                    tree.tag,
                    parameters,
                    errors
                )
            }
        }
    }

    fn from_array_tree_array(
        config:&FromArrayTreeConfig,
        tree:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> Result<WithTag<Self>, ()>;

    
    fn from_array_tree_string(
        config:&FromArrayTreeConfig,
        leaf:StringLeaf,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> Result<WithTag<Self>, ()>;


    fn match_array_tree(
        config:&FromArrayTreeConfig,
        tree:WithTag<ArrayTree<StringLeaf>>,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> bool {
        match tree.data {
            ArrayTree::Array(array) => {
                Self::match_array_tree_array(
                    config,
                    array,
                    tree.tag,
                    parameters,
                    errors
                )
            }
            ArrayTree::Leaf(string) => {
                Self::match_array_tree_string(
                    config,
                    string,
                    tree.tag,
                    parameters,
                    errors
                )
            }
        }
    }

    fn match_array_tree_array(
        config:&FromArrayTreeConfig,
        tree:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> bool;

    fn match_array_tree_string(
        config:&FromArrayTreeConfig,
        leaf:StringLeaf,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> bool;
}

pub struct FromArrayTreeConfig {
    // 各文字を入力した後に、エラーが数がいくつ以下であれば処理を継続するか？
    pub continuous_error_limit: usize,
}
