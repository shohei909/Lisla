use template::error::PlaceholderCompleteError;
use data::position::*;
use tag::*;

#[derive(Error)]
#[derive(Debug, Clone)]
pub enum ParseStringError {
    Parse(ParseError),
    PlaceholderComplete(PlaceholderCompleteError),
}

#[derive(Error)]
#[derive(Debug, Clone)]
pub enum ParseError {
    NotUtf8(NotUtf8Error),
    Io(IoError),
    
    UnclosedQuote(UnclosedQuoteError),
    UnclosedArray(UnclosedArrayError),
    
    BlacklistedWhiteSpace(BlacklistedWhiteSpaceError),
    TooManyClosingBrackets(TooManyClosingBracketsError),
    TooLongClosingQuote(TooLongClosingQuoteError),
    UnmatchedIndent(UnmatchedIndentError),
    
    InvalidPlaceholderPosition(InvalidPlaceholderPositionError),
    EmptyPlaceholder(EmptyPlaceholderError),

    SeparaterRequired(SeparaterRequiredError),
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "unclosed quote found"]
#[code = "7892a647-f507-4988-ae32-dc7380113fcd"]
pub struct UnclosedQuoteError {
    pub range: Range,
    pub quote: Quote,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "unclosed array found"]
#[code = "c4d2ec90-3b8f-4a93-b4c8-bccd2b3ebb40"]
pub struct UnclosedArrayError {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "invalid escape sequence"]
#[code = "38d42150-1047-428b-b68c-688c0c1b9e1b"]
pub struct InvalidEscapeError {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "blacklisted whitespace `\\u{{}}` is used"]
#[code = "6f7adbd9-9b1c-4fda-a11a-eddc49d1bd19"]
pub struct BlacklistedWhiteSpaceError {
    pub range: Range,
    pub character: char,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "too many closing brackets"]
#[code = "3055cdc2-475e-4d4e-ac68-a586ede479d5"]
pub struct TooManyClosingBracketsError {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "too long closing quote"]
#[code = "7afbcea2-0b6e-4abf-a945-8c1468f99ff7"]
pub struct TooLongClosingQuoteError {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "indent must be same"]
#[code = "d4965a3b-4819-44ef-9657-c1188bd4bcae"]
pub struct UnmatchedIndentError {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "io error"]
#[code = "ac0d0db7-751d-42a7-810e-fa2442b93287"]
pub struct IoError {
    pub range: Range,
    pub reason: IoErrorReason, 
}

#[derive(Debug)]
pub struct IoErrorReason {
    pub error: ::std::io::Error,
}

impl Clone for IoErrorReason {
    fn clone(&self) -> IoErrorReason {
        IoErrorReason {
            error: ::std::io::Error::new(
                self.error.kind(),
                ::std::error::Error::description(&self.error)
            )
        }
    }
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "non utf8 character found"]
#[code = "a2c38664-be73-47da-88f1-87107ae9f862"]
pub struct NotUtf8Error {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "invalid unicode"]
#[code = "fc4db99b-0cb1-4674-8d11-9c961e9f15d3"]
pub struct InvalidUnicodeError {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "digit of unicode must be 1-6"]
#[code = "dfe778ce-5f90-46f9-8bda-093c644976c8"]
pub struct InvalidUnicodeDigitError {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "invalid placeholder position"]
#[code = "9fae0ca2-1489-4cd6-aaef-5c9a0f6b380d"]
pub struct InvalidPlaceholderPositionError {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "empty placeholder"]
#[code = "25577736-d376-4444-8218-1aca1efadd60"]
pub struct EmptyPlaceholderError {
    pub range: Range,
}

#[derive(Error)]
#[derive(Debug, Clone)]
#[message = "separater required"]
#[code = "e333e39e-e455-44e2-9f36-3b3a6cea0af5"]
pub struct SeparaterRequiredError {
    pub range: Range,
}
