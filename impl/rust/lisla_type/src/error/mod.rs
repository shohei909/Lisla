use lisla_core::data::position::*;

#[derive(Error)]
#[derive(Debug, Clone)]
pub enum FromArrayTreeError {
    TooManyArguments(TooManyArgumentsError),
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "too many arguments"]
#[code = "eb24aba7-40a9-48e2-a698-50e72b0a0c95"]
pub struct TooManyArgumentsError {
    range: Range,
}
