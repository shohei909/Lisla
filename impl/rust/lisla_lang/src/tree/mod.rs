
use tag::*;
use std::fmt::Debug;
use from::error::*;
use from::*;
use ::error::*;
use leaf::*;

#[derive(Debug, Clone, Eq, PartialEq)]
pub enum ArrayTree<LeafType:Leaf> {
    Array(ArrayBranch<WithTag<ArrayTree<LeafType>>>),
    Leaf(LeafType),
}

impl FromArrayTree for ArrayTree<StringLeaf> {
    type Parameters = ();

    #[allow(unused_variables)]
    fn from_array_tree(
        config:&FromArrayTreeConfig, 
        tree:WithTag<ArrayTree<StringLeaf>>, 
        parameters: (),
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<WithTag<ArrayTree<StringLeaf>>, ()> {
        Result::Ok(tree)
    }

    #[allow(unused_variables)]
    fn from_array_tree_array(
        config:&FromArrayTreeConfig,
        array:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> Result<WithTag<Self>, ()> {
        Result::Ok(
            WithTag {
                data: ArrayTree::Array(array),
                tag,
            }
        )
    }

    #[allow(unused_variables)]
    fn from_array_tree_string(
        config:&FromArrayTreeConfig,
        leaf:StringLeaf,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> Result<WithTag<Self>, ()> {
        Result::Ok(
            WithTag {
                data: ArrayTree::Leaf(leaf),
                tag,
            }
        )
    }

    #[allow(unused_variables)]
    fn match_array_tree_array(
        config:&FromArrayTreeConfig,
        array:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>, 
        tag:Tag,
        parameters: Self::Parameters,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> bool {
        true
    }
    
    #[allow(unused_variables)]
    fn match_array_tree_string(
        config:&FromArrayTreeConfig,
        leaf:StringLeaf,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> bool {
        false
    }
}

impl<LeafType:Leaf> From<ArrayBranch<WithTag<ArrayTree<LeafType>>>> for ArrayTree<LeafType> {
    fn from(data:ArrayBranch<WithTag<ArrayTree<LeafType>>>) -> Self {
        ArrayTree::Array(data)
    }
}

impl<LeafType:Leaf> ArrayTree<LeafType> {
    pub fn to_branch(self) -> Option<ArrayBranch<WithTag<ArrayTree<LeafType>>>> {
        match self {
            ArrayTree::Array(branch) => Option::Some(branch),
            ArrayTree::Leaf(_) => Option::None,
        }
    }
    pub fn to_leaf(self) -> Option<LeafType> {
        match self {
            ArrayTree::Array(_) => Option::None,
            ArrayTree::Leaf(leaf) => Option::Some(leaf),
        }
    }
}

pub trait Tree<LeafType> {}
impl<LeafType:Leaf> Tree<LeafType> for ArrayTree<LeafType> {}

#[derive(Debug, Clone, Eq, PartialEq)]
pub struct ArrayBranch<TreeType:Debug + Clone> {
    pub vec: Vec<TreeType>,
}

impl<TreeType:Debug + Clone> ArrayBranch<TreeType> {
    
    #[allow(unused_variables)]
    pub fn shift(
        &mut self,
        config: &FromArrayTreeConfig,
        tag: &Tag,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<TreeType, ()> {
        if self.vec.len() == 0 {
            let range = tag.content_range.clone();
            errors.push(FromArrayTreeError::from(NotEnoughArgumentsError{ range }));
            Result::Err(())
        } else {
            Result::Ok(
                self.vec.remove(0)
            )
        }
    }

    #[allow(unused_variables)]
    pub fn split_off(
        &mut self, 
        config: &FromArrayTreeConfig,
        len:usize,
        tag: &Tag,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<Self, ()> {
        if self.vec.len() < len {
            let range = tag.content_range.clone();
            errors.push(FromArrayTreeError::from(NotEnoughArgumentsError{ range }));
            Result::Err(())
        } else {
            Result::Ok(
                Self { vec: self.vec.split_off(len) }
            )
        }
    }

    pub fn split_off_rest(
        &mut self,
        config: &FromArrayTreeConfig,
        tag: &Tag,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<Self, ()> {
        let len = self.vec.len();
        self.split_off(config, len, tag, errors)
    }

    #[allow(unused_variables)]
    pub fn finish(
        self,
        config: &FromArrayTreeConfig,
        tag: &Tag,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<(), ()> {
        if self.vec.len() == 0 {
            Result::Ok(())
        } else {
            let range = tag.content_range.clone();
            errors.push(FromArrayTreeError::from(TooManyArgumentsError{ range }));
            Result::Err(())
        }
    }
}

impl<T:Debug + Clone + FromArrayTree> FromArrayTree for ArrayBranch<WithTag<T>> {
    type Parameters = T::Parameters;
    
    fn from_array_tree_array(
        config:&FromArrayTreeConfig,
        array:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>, 
        tag:Tag,
        parameters: T::Parameters,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> Result<WithTag<ArrayBranch<WithTag<T>>>, ()> {
        let mut vec = Vec::new();
        for element in array.vec {
            match FromArrayTree::from_array_tree(
                config, 
                element,
                parameters.clone(),
                errors
            ) {
                Result::Ok(data) => {
                    vec.push(data);
                }
                Result::Err(()) => {}
            }
            
            if config.continuous_error_limit < errors.len() {
                return Result::Err(());
            }
        }

        Result::Ok(
            WithTag {
                data: ArrayBranch { vec },
                tag
            }
        )
    }

    #[allow(unused_variables)]
    fn from_array_tree_string(
        config:&FromArrayTreeConfig,
        leaf:StringLeaf,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> Result<WithTag<Self>, ()> {
        errors.push(
            FromArrayTreeError::from(
                CantBeStringError {
                    range: tag.content_range
                }
            )
        );
        Result::Err(())
    }

    #[allow(unused_variables)]
    fn match_array_tree_array(
        config:&FromArrayTreeConfig,
        array:ArrayBranch<WithTag<ArrayTree<StringLeaf>>>, 
        tag:Tag,
        parameters: T::Parameters,
        errors: &mut ErrorWrite<FromArrayTreeError>,
    ) -> bool {
        true
    }
    
    #[allow(unused_variables)]
    fn match_array_tree_string(
        config:&FromArrayTreeConfig,
        leaf:StringLeaf,
        tag:Tag,
        parameters: Self::Parameters,
        errors:&mut ErrorWrite<FromArrayTreeError>
    ) -> bool {
        false
    }
}
