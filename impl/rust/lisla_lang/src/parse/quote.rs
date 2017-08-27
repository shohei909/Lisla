use tag::*;
use data::position::*;
use super::*;
use super::array::*;
use super::string::*;

#[derive(Debug, Clone)]
pub struct QuoteContext {
    pub quote: Quote,
    pub close_count: usize,
}

impl QuoteContext {
    pub fn process(
        mut self, 
        input: &CharacterInput, 
        mut data: StringData,
        errors: &mut ErrorWrite<ParseError>, 
    ) -> ProcessAction {
        let context = match (input.character, self.quote.kind) {
            ('\'', QuoteKind::Single) | ('\"', QuoteKind::Double) => {
                self.close_count += 1;
                StringBodyContext {
                    quote: Option::Some(self),
                }
            }

            _ => {
                if self.close_count < self.quote.count {
                    for _ in 0..self.close_count {
                        data.content.push(self.quote.kind.character());
                    }
                    
                    self.close_count = 0;
                    data.content.push(input.character);
                    StringBodyContext {
                        quote: Option::Some(self),
                    }
                } else {
                    if self.quote.count < self.close_count {
                        let range = Range::with_length(
                            input.index - self.quote.count, 
                            self.quote.count
                        );
                        errors.push(ParseError::from(TooLongClosingQuoteError{ range }));
                    }
                    return data.complete_and_process(
                        input, 
                        Option::Some(self.quote),
                        errors,
                    );
                }
            }
        };
        
        data.continue_body(context)
    }

    pub fn complete(
        self, 
        input: &EndInput, 
        data: StringData,
        errors: &mut ErrorWrite<ParseError>, 
    ) -> WithTag<ArrayTree<TemplateLeaf>> {
        if self.close_count < self.quote.count {
            let range = Range::with_end(data.start, input.index);
            errors.push(ParseError::from(UnclosedQuoteError{ range, quote: self.quote.clone() }));
            data.complete(input.config, input.index, Option::Some(self.quote), errors)
        } else {
            if self.quote.count < self.close_count {
                let range = Range::with_length(
                    input.index - self.quote.count, 
                    self.quote.count
                );
                errors.push(ParseError::from(TooLongClosingQuoteError{ range }));
            }
            
            data.complete(input.config, input.index, Option::Some(self.quote), errors)
        }
    }
}
