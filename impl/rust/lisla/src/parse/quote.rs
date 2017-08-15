use data::tag::*;
use data::leaf::*;
use data::position::*;
use super::*;
use super::array::*;
use super::string::*;
use super::escape::*;
use super::space::is_blacklist_whitespace;

#[derive(Debug, Clone)]
pub struct QuoteContext {
    pub quote: Quote,
    pub close_count: usize,
}

impl QuoteContext {
    pub fn process(
        self, 
        input: &CharacterInput, 
        mut data: StringData,
        errors: &mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        let context = match (input.character, self.quote.kind) {
            ('\'', QuoteKind::Single) | ('\'', QuoteKind::Single) => {
                StringBodyContext {
                    quote: Option::Some(self),
                    escape: Option::None,
                }
            }
            _ => {
                for _ in 0..self.close_count {
                    data.content.push(self.quote.kind.character());
                }

                match (input.character, self.quote.kind) {
                    ('\\', QuoteKind::Double) => {
                        StringBodyContext {
                            quote: Option::Some(self),
                            escape: Option::Some(EscapeContext::Top),
                        }
                    }

                    (_, _) => {
                        data.content.push(input.character);
                        StringBodyContext {
                            quote: Option::Some(self),
                            escape: Option::None,
                        }
                    }
                }
            }
        };
        
        data.continue_action(
            StringContextKind::Body(context)
        )
    }

    pub fn complete(
        self, 
        input: &EndInput, 
        data: StringData,
        errors: &mut ErrorWrite<ParseError>
    ) -> ATree<TemplateLeaf> {
        let range = Range::with_end(data.start, input.index);
        errors.push(ParseError::from(UnclosedQuoteError{ range, quote: self.quote.clone() }));
        data.complete(input.index, Option::Some(self.quote))
    }
}
