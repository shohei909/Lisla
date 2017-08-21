use std::fmt::Debug;

pub trait StringNewtype : 
    From<String> +  
    Clone +
    Debug +
    Ord
{
    fn new(value:String) -> Self;
}

pub trait I64Newtype : 
    From<i64> +  
    Clone +
    Copy +
    Debug +
    Ord
{
    fn new(value:String) -> Self;
}
