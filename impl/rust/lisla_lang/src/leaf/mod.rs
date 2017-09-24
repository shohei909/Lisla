use tag::*;
use from::error::*;
use from::*;
use ::error::*;
use std::fmt::Debug;
use tree::*;

#[derive(Debug, Clone, Eq, PartialEq)]
pub struct StringLeaf {
    pub string: String
}

impl StringLeaf {
    pub fn new (string:String) -> Self {
        StringLeaf { string }
    }
}

impl From<String> for StringLeaf {
    fn from(string:String) -> Self {
        StringLeaf::new(string)
    }
}

impl FromArrayTree for StringLeaf {
    type Parameters = ();

    #[allow(unused_variables)]
    fn from_array_tree_array(
        config:&FromArrayTreeConfig,
        tree:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> Result<WithTag<Self>, ()> {
        errors.push(
            FromArrayTreeError::from(
                CantBeArrayError {
                    range: tag.content_range
                }
            )
        );
        Result::Err(())
    }

    #[allow(unused_variables)]
    fn from_array_tree_string(
        config:&FromArrayTreeConfig, 
        data:StringLeaf, 
        tag:Tag,
        parameters: (),
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<WithTag<StringLeaf>, ()> {
        Result::Ok(WithTag{ data, tag })
    }

    #[allow(unused_variables)]
    fn match_array_tree_array(
        config:&FromArrayTreeConfig,
        tree:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>,
        tag:Tag,
        parameters: (),
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> bool {
        false
    }

    #[allow(unused_variables)]
    fn match_array_tree_string(
        config:&FromArrayTreeConfig, 
        data:StringLeaf, 
        tag:Tag,
        parameters: (),
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> bool {
        true
    }
}

impl Leaf for StringLeaf {
}

pub trait Leaf : Debug + Clone + Eq + PartialEq {
}
