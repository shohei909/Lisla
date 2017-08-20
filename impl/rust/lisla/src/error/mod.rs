use std::fmt::{self, Display, Debug};
use std::clone::Clone;
use data::position::Position;

pub trait Error : Position {
    fn message(&self) -> String;
    fn code(&self) -> ErrorCode;
    fn name(&self) -> String;
}

impl Display for Error {
    fn fmt(&self, formatter: &mut fmt::Formatter) -> Result<(), fmt::Error> {
        let position_string = self.position_string();
        write!(
            formatter, 
            "{}: {} ({}:{})", 
            position_string, 
            self.message(),
            self.name(),
            self.code().value,
        )?;

        Result::Ok(())
    }
}

//#[derive(StringNewtype)]

#[derive(Debug, Clone)]
pub struct ErrorCode { pub value:String }

pub trait ErrorHolder {
    fn child_error(&self) -> &Error;
}

#[derive(Debug, Clone)]
pub struct ResumableResult<Data, Error> where
    Data: Clone + Debug, 
    Error: Clone + Debug
{
    pub data: Option<Data>,
    pub errors: Errors<Error>,
}

impl<Data, Error> ResumableResult<Data, Error> where
    Data: Clone + Debug, 
    Error: Clone + Debug
{
    pub fn new(data:Option<Data>, errors:Errors<Error>) -> Self {
        ResumableResult{ data, errors }
    }

    pub fn ok(data:Data) -> Self {
        ResumableResult::new(Option::Some(data), Errors::new())
    }

    pub fn error(errors:Errors<Error>) -> Self {
        ResumableResult::new(Option::None, errors)
    }

    pub fn error_with_data(errors:Errors<Error>, data:Data) -> Self {
        ResumableResult::new(Option::Some(data), errors)
    }

    pub fn to_result(self) -> Result<Data, Errors<Error>> {
        match self.data {
            Option::Some(data) => {
                if self.errors.len() == 0 {
                    Result::Ok(data)
                } else {
                    Result::Err(self.errors)
                }
            }
            Option::None => Result::Err(self.errors),
        }
    }

    pub fn unwrap(self) -> Data {
        self.to_result().unwrap()
    }
    
    pub fn unwrap_err(self) -> Errors<Error> {
        self.to_result().unwrap_err()
    }
}


pub trait ErrorWrite<Error> {
    fn len(&self) -> usize;
    fn push(&mut self, data:Error);
}

#[derive(Debug, Clone)]
pub struct Errors<Error: Debug + Clone> {
    pub errors: Vec<Error>,
}

impl<Error: Debug + Clone> Errors<Error> {
    pub fn new() -> Self {
        Errors{ errors:Vec::new() }
    }
}

impl<Error: Debug + Clone> ErrorWrite<Error> for Errors<Error> {
    fn len(&self) -> usize {
        self.errors.len()
    }
    
    fn push(&mut self, data:Error) {
        self.errors.push(data);
    }
}

pub struct ErrorsWrapper<'a, Error> 
    where Error: 'a
{
    pub errors: &'a mut ErrorWrite<Error>,
}

impl<'a, ErrorA, ErrorB> ErrorWrite<ErrorA> for ErrorsWrapper<'a, ErrorB> where 
    ErrorB: From<ErrorA>
{
    fn len(&self) -> usize {
        self.errors.len()
    }
    
    fn push(&mut self, data:ErrorA) {
        self.errors.push(ErrorB::from(data));
    }
} 
