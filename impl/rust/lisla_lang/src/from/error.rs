use data::position::*;

#[derive(Error)]
#[derive(Debug, Clone)]
pub enum FromArrayTreeError {
    CantBeString(CantBeStringError),
    CantBeArray(CantBeArrayError),
    NotEnoughArguments(NotEnoughArgumentsError),
    TooManyArguments(TooManyArgumentsError),
    UnmatchedConst(UnmatchedConstError),
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "can't be array"]
#[code = "7a4886d9-0f6f-4c49-b9d0-a4d7fefc21c2"]
pub struct CantBeArrayError {
    pub range: Option<Range>,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "can't be string"]
#[code = "6fc7339c-4709-4dd3-ad5b-1b544a5fc4b1"]
pub struct CantBeStringError {
    pub range: Option<Range>,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "too many arguments"]
#[code = "9270d030-db28-44c5-b448-dd8a6292688e"]
pub struct TooManyArgumentsError {
    pub range: Option<Range>,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "not enough arguments"]
#[code = "82d64f56-748b-45c7-b7bb-0660356fbe27"]
pub struct NotEnoughArgumentsError {
    pub range: Option<Range>,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "unmatched label"]
#[code = "ca06a2a2-7e82-4a48-b9c7-b88030bb7c72"]
pub struct UnmatchedConstError {
    pub range: Option<Range>,
}
