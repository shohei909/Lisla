use tag::*;
use from::error::*;
use from::*;
use ::error::*;
use std::fmt::Debug;

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
    fn from_array_tree_string(
        config:&FromArrayTreeConfig, 
        data:StringLeaf, 
        tag:Tag,
        parameters: (),
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<WithTag<StringLeaf>, ()> {
        Result::Ok(WithTag{ data, tag })
    }
}

impl Leaf for StringLeaf {
}

pub trait Leaf : Debug + Clone + Eq + PartialEq {
}
