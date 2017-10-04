use ::arraytree_lang::tag::*;
use ::arraytree_lang::leaf::*;
use ::arraytree_lang::from::*;
use ::arraytree_lang::from::error::*;
use ::arraytree_lang::tree::*;
use ::arraytree_core::error::*;

#[derive(Debug, Clone)]
pub struct Const {
    pub value: ArrayTree<StringLeaf>,
}

impl FromArrayTree for Const {
    type Parameters = (ArrayTree<StringLeaf>);
    
    #[allow(unused_variables)]
    fn from_array_tree(
        config:&FromArrayTreeConfig, 
        tree: WithTag<ArrayTree<StringLeaf>>,
        parameters: Self::Parameters,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<WithTag<Const>, ()> {
        if tree.data == parameters {
            Result::Ok(
                WithTag {
                    data: Const { value: tree.data },
                    tag: tree.tag,
                }
            )
        } else {
            errors.push(
                FromArrayTreeError::from(
                    UnmatchedConstError {
                        range: tree.tag.content_range
                    }
                )
            );
            Result::Err(())
        }
    }
    
    #[allow(unused_variables)]
    fn from_array_tree_array(
        config:&FromArrayTreeConfig, 
        tree:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>,
        tag:Tag,
        parameters: Self::Parameters,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<WithTag<Self>, ()> {
        Self::from_array_tree(
            config,
            WithTag {
                data: ArrayTree::Array(tree),
                tag
            },
            parameters,
            errors
        )
    }

    #[allow(unused_variables)]
    fn from_array_tree_string(
        config:&FromArrayTreeConfig, 
        leaf:StringLeaf, 
        tag:Tag,
        parameters: Self::Parameters,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<WithTag<Self>, ()> {
        Self::from_array_tree(
            config,
            WithTag {
                data: ArrayTree::Leaf(leaf),
                tag
            },
            parameters,
            errors
        )
    }

    #[allow(unused_variables)]
    fn match_array_tree(
        config:&FromArrayTreeConfig,
        tree:WithTag<ArrayTree<StringLeaf>>,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> bool {
        tree.data == parameters
    }

    #[allow(unused_variables)]
    fn match_array_tree_array(
        config:&FromArrayTreeConfig,
        tree:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> bool {
        Self::match_array_tree(
            config,
            WithTag {
                data: ArrayTree::Array(tree),
                tag
            },
            parameters,
            errors
        )
    }

    #[allow(unused_variables)]
    fn match_array_tree_string(
        config:&FromArrayTreeConfig, 
        leaf:StringLeaf, 
        tag:Tag,
        parameters: Self::Parameters,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> bool {
        Self::match_array_tree(
            config,
            WithTag {
                data: ArrayTree::Leaf(leaf),
                tag
            },
            parameters,
            errors
        )
    }
}
