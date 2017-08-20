use super::*;
use data::position::Range;

#[derive(Error)]
#[derive(Debug, Clone)]
#[message("failed to bind variables to placeholder")]
#[code = "2abc0deb-9fbb-4b11-9bcc-14a2a48105a9"]
pub struct PlaceholderCompleteError {
    pub placeholder: Placeholder,
    pub range: Range,
}
