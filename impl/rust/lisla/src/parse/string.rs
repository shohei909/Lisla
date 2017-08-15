use data::tag::*;
use data::leaf::*;
use data::position::*;
use super::*;
use super::array::*;
use super::escape::*;
use super::quote::*;
use super::space::is_blacklist_whitespace;
use super::error::*;

#[derive(Debug, Clone)]
pub struct StringContext {
    data: StringData,
    kind: StringContextKind,
}

impl StringContext {
    pub fn process_first_character(
        input: &CharacterInput,
        leading_space: Option<Space>,
        errors: &mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        let data = StringData::new(input.index, leading_space);

        let kind = match input.character {
            '\'' => {
                let head = StringHeadContext::new(QuoteKind::Single);
                StringContextKind::Head(head)
            }
            
            '\"' => {
                let head = StringHeadContext::new(QuoteKind::Double);
                StringContextKind::Head(head)
            }

            _ => {
                let body = StringBodyContext::new();
                return body.process(input, data, errors);
            }
        };

        Self::string_action(data, kind)
    }

    pub fn process(
        self, 
        input:&CharacterInput, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        match self.kind {
            StringContextKind::Head(context) => {
                context.process(input, self.data, errors)
            }

            StringContextKind::Body(context) => {
                context.process(input, self.data, errors)
            }
        }
    }
    
    fn string_action(data:StringData, kind:StringContextKind) -> ProcessAction { 
        ProcessAction::Next(
            ArrayContextKind::String(
                StringContext { data, kind }
            )
        )
    }

    // ファイルの末尾まで来たので、文字列を生成して
    pub fn complete(
        self, 
        input:&EndInput, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ATree<TemplateLeaf> {
        match self.kind {
            StringContextKind::Head(context) => {
                context.complete(input, self.data, errors)
            }

            StringContextKind::Body(context) => {
                context.complete(input, self.data, errors)
            }
        }
    }
}

#[derive(Debug, Clone)]
pub struct StringData {
    pub start: usize,
    pub content: String,
    pub raw_content: String,
    pub leading_space: Option<Space>,
}

impl StringData {
    pub fn new(start:usize, leading_space:Option<Space>) -> StringData {
        StringData {
            start,
            leading_space,
            raw_content: String::new(),
            content: String::new(),
        }
    }

    pub fn complete(
        self, 
        end_index:usize, 
        quote:Option<Quote>
    ) -> ATree<TemplateLeaf> {
        let range = Range::with_end(self.start, end_index);
        let leaf_tag = LeafTag{ raw_content:self.raw_content, quote };
        let node_kind = Option::Some(TagKind::Leaf(leaf_tag));
        let tag = Tag::new(self.leading_space, range, node_kind);
        let leaf = TemplateLeaf::String(String::new());

        ATree::Leaf(
            Leaf { leaf, tag }
        )
    }

    pub fn continue_action(self, kind:StringContextKind) -> ProcessAction {
        ProcessAction::Next(
            ArrayContextKind::String(
                StringContext {
                    data: self,
                    kind
                }
            )
        )
    }
}

#[derive(Debug, Clone)]
struct StringLine {
    pub range: Range,
    pub indent: String,
    pub content: String,
    pub newline: Option<NewlineKind>,
}

#[derive(Debug, Clone)]
pub enum StringContextKind {
    Head(StringHeadContext),
    Body(StringBodyContext),
}

#[derive(Debug, Clone)]
pub struct StringHeadContext {
    quote: Quote,
}

impl StringHeadContext {
    pub fn new(kind: QuoteKind) -> StringHeadContext {
        let quote = Quote { kind, count: 1 };
        StringHeadContext { quote }
    }
    
    pub fn process(
        mut self, 
        input:&CharacterInput, 
        data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        match (input.character, self.quote.kind) {
            ('\"', QuoteKind::Single) | ('\'', QuoteKind::Double) => {
                self.quote.count += 1;
                let kind = StringContextKind::Head(self);
                ProcessAction::Next(
                    ArrayContextKind::String(
                        StringContext { data, kind }
                    )
                )
            }
            (_, _) => {
                // FIXME: 2-quotes
                let body = StringBodyContext{
                    quote: Option::Some(
                        QuoteContext {
                            quote: self.quote,
                            close_count: 0,
                        }
                    ),
                    escape: Option::None,
                };
                body.process(input, data, errors)
            }
        }
    }

    pub fn complete(
        self, 
        input:&EndInput, 
        data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ATree<TemplateLeaf> {
        if self.quote.count != 2 {
            self.quote.count - 1;
        } else {
            let range = Range::with_end(data.start, input.index);
            errors.push(ParseError::from(UnclosedQuoteError{ range, quote: self.quote.clone() }));
        }
        
        data.complete(input.index, Option::Some(self.quote))
    }
}

#[derive(Debug, Clone)]
pub struct StringBodyContext {
    pub quote: Option<QuoteContext>,
    pub escape: Option<EscapeContext>,
}

impl StringBodyContext {
    pub fn new() -> StringBodyContext {
        StringBodyContext {
            quote: Option::None,
            escape: Option::None,
        }
    }

    pub fn process(
        self, 
        input:&CharacterInput, 
        mut data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        match self.escape {
            Option::None => {
                match self.quote {
                    Option::None => {
                        self.process_none(input, data, errors)
                    }
                    Option::Some(quote) => {
                        quote.process(input, data, errors)
                    }
                }
            }

            Option::Some(escape) => {
                match escape.process(input, errors) {
                    EscapeAction::Continue(escape) => {
                        data.continue_action(
                            StringContextKind::Body(
                                StringBodyContext {
                                    quote: self.quote,
                                    escape: Option::Some(escape),
                                }
                            )
                        )
                    }

                    EscapeAction::End(character) => {
                        if let Option::Some(character) = character {
                            data.content.push(character);
                        }

                        data.continue_action(
                            StringContextKind::Body(
                                StringBodyContext {
                                    quote: self.quote,
                                    escape: Option::None,
                                }
                            )
                        )
                    }

                    EscapeAction::Placeholder(placeholder) => {
                        let range = Range::with_end(data.start, input.index + 1);
                        if data.content.len() == 0 && self.quote.is_none() {
                            // クオート無し文字列の頭から、プレースホルダーが始まってる場合のみ正しい
                            let tag_kind = TagKind::Leaf(
                                LeafTag {  
                                    quote: Option::None,
                                    raw_content: data.raw_content,
                                }
                            );
                            let leaf = Leaf {
                                leaf: TemplateLeaf::Placeholder(placeholder),
                                tag: Tag::new(data.leading_space, range, Option::Some(tag_kind))
                            };
                            let element = ATree::Leaf(leaf);
                            let context = SpaceContext::new(input.index + 1);
                            ProcessAction::Add{
                                element,
                                action: Box::new(
                                    ProcessAction::Next(
                                        ArrayContextKind::Space(context),
                                    )
                                )
                            }
                        } else {
                            // 不正な位置での、Placeholder
                            errors.push(ParseError::from(InvalidPlaceholderPositionError{ range }));
                            
                            // 修復方法：プレースホルダーの内容は無視してそのまま続行
                            data.continue_action(
                                StringContextKind::Body(
                                    StringBodyContext {
                                        quote: self.quote,
                                        escape: Option::None,
                                    }
                                )
                            )
                        }
                    }
                }
            }
        }
    }

    pub fn process_none(
        mut self, 
        input:&CharacterInput, 
        mut data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        let character = input.character;
        match character {
            ' ' | '\t' | '\r' | '\n' | '[' | ']' | '\'' | '\"' => {
                self.complete_and_process(input, data, errors)
            }

            _ if is_blacklist_whitespace(character) => {
                self.complete_and_process(input, data, errors)
            }

            '\\' => {
                self.escape = Option::Some(EscapeContext::Top);
                data.continue_action(
                    StringContextKind::Body(self)
                )
            }

            _ => {
                data.content.push(character);
                data.continue_action(
                    StringContextKind::Body(self)
                )
            }
        }
    }
    
    fn complete_and_process(
        self, 
        input:&CharacterInput, 
        data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    )  -> ProcessAction {
        let element = data.complete(input.index, Option::None);
        let context = SpaceContext::new(input.index);
        let action = context.process(input, errors);

        ProcessAction::Add {
            element,
            action: Box::new(action),
        }
    }

    pub fn complete(
        self, 
        input:&EndInput, 
        data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ATree<TemplateLeaf> {
        if let Option::Some(escape) = self.escape {
            let range = Range::with_end(data.start, input.index);
            errors.push(ParseError::from(InvalidEscapeError{ range }));
        };

        match self.quote {
            Option::None => {
                data.complete(input.index, Option::None)
            }
            Option::Some(quote) => {
                quote.complete(input, data, errors)
            }
        }
    }
}
