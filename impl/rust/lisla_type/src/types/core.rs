use ::lisla_lang::tag::*;
use ::lisla_lang::leaf::*;
use ::lisla_lang::from::*;
use ::lisla_lang::from::error::*;
use ::lisla_lang::tree::*;
use ::lisla_core::error::*;

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
}

