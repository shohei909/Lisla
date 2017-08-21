use tag::*;
use tree::leaf::*;
use data::position::*;
use super::*;
use super::array::*;
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
        let mut data = StringData::new(input.index, leading_space);

        let head = match input.character {
            '\'' => {
                StringHeadContext::Quote{ 
                    quote: Quote::new(QuoteKind::Single),
                }
            }
            
            '\"' => {
                StringHeadContext::Quote{ 
                    quote: Quote::new(QuoteKind::Double),
                }
            }

            '$' => {
                data.is_placeholder = true;
                StringHeadContext::Placeholder
            }

            _ => {
                let body = StringBodyContext::new();
                return body.process(input, data, errors);
            }
        };

        data.continue_head(head)
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
    pub leading_space: Option<Space>,
    pub is_placeholder: bool,
}

impl StringData {
    pub fn new(start:usize, leading_space:Option<Space>) -> StringData {
        StringData {
            start,
            leading_space,
            content: String::new(),
            is_placeholder: false,
        }
    }

    pub fn complete(
        mut self, 
        config: &ParseConfig,
        end_index:usize,
        quote:Option<Quote>,
        errors:&mut ErrorWrite<ParseError>,
    ) -> ATree<TemplateLeaf> {
        let range = Range::with_end(self.start, end_index);
        let node_kind = match config.tag_infomation {
            TagInfomationLevel::All => {
                let raw_content = self.content.clone();
                let leaf_tag = LeafTag{ 
                    raw_content, 
                    quote: quote.clone(),
                    is_placeholder: self.is_placeholder
                };
                Option::Some(TagKind::Leaf(leaf_tag))
            }
            
            TagInfomationLevel::Low => {
                Option::None
            }
        };

        match quote {
            Option::None => {}

            Option::Some(quote) => {
                self.content = remove_content_indent(
                    self.start + quote.count,
                    self.content,
                    errors,
                );
            }
        }

        let tag = Tag::new(self.leading_space, range, node_kind);
        let leaf = if self.is_placeholder {
            TemplateLeaf::Placeholder(Placeholder{ key: self.content })
        } else {
            TemplateLeaf::String(self.content)
        };

        ATree::Leaf(
            Leaf { leaf, tag }
        )
    }

    fn continue_action(self, kind:StringContextKind) -> ProcessAction {
        ProcessAction::Next(
            ArrayContextKind::String(
                StringContext {
                    data: self,
                    kind
                }
            )
        )
    }

    pub fn complete_and_process(
        self, 
        input:&CharacterInput, 
        quote: Option<Quote>,
        errors:&mut ErrorWrite<ParseError>,
    ) -> ProcessAction {
        let element = self.complete(input.config, input.index, quote, errors);
        let context = SpaceContext::new(input.index, true);
        let action = context.process(input, errors);

        ProcessAction::Add {
            element,
            action: Box::new(action),
        }
    }

    pub fn continue_head(self, next:StringHeadContext) -> ProcessAction {
        self.continue_action(StringContextKind::Head(next))
    }
    
    pub fn continue_body(self, next:StringBodyContext) -> ProcessAction {
        self.continue_action(StringContextKind::Body(next))
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
pub enum StringHeadContext {
    Placeholder,
    Quote {
        quote: Quote
    },
}

impl StringHeadContext {
    pub fn process(
        self, 
        input:&CharacterInput, 
        data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        match self {
            StringHeadContext::Quote{ mut quote } =>
                match (input.character, quote.kind) {
                    ('\"', QuoteKind::Double) | ('\'', QuoteKind::Single) => {
                        quote.count += 1;
                        let next = StringHeadContext::Quote{ quote };
                        data.continue_head(next)
                    }
                    (_, _) => {
                        if quote.count == 2 {
                            quote.count - 1;
                            data.complete_and_process(
                                input, 
                                Option::Some(quote), 
                                errors
                            )
                        } else {
                            let body = StringBodyContext{
                                quote: Option::Some(
                                    QuoteContext {
                                        quote: quote,
                                        close_count: 0,
                                    }
                                ),
                            };
                            body.process(input, data, errors)
                        }
                    }
                }

            StringHeadContext::Placeholder => {
                match input.character {
                    '\'' => {
                        let head = StringHeadContext::Quote{ 
                            quote: Quote::new(QuoteKind::Single),
                        };
                        data.continue_head(head)
                    }
                    
                    '\"' => {
                        let head = StringHeadContext::Quote{ 
                            quote: Quote::new(QuoteKind::Double),
                        };
                        data.continue_head(head)
                    }

                    '$' => {
                        // 不正な$
                        let range = Range::with_length(input.index, 1);
                        errors.push(ParseError::from(InvalidPlaceholderPositionError { range }));

                        // 復帰方法: この$を無視
                        data.continue_head(self)
                    }

                    _ => {
                        let body = StringBodyContext::new();
                        body.process(input, data, errors)
                    }
                }
            }
        }
    }

    pub fn complete(
        self, 
        input:&EndInput, 
        data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ATree<TemplateLeaf> {
        match self {
            StringHeadContext::Quote{ quote } => {
                if quote.count == 2 {
                    quote.count - 1;
                } else {
                    let range = Range::with_end(data.start, input.index);
                    errors.push(ParseError::from(UnclosedQuoteError{ range, quote: quote.clone() }));
                }
        
                data.complete(input.config, input.index, Option::Some(quote), errors)
            }

            StringHeadContext::Placeholder => {
                let range = Range::with_end(data.start, input.index);
                errors.push(ParseError::from(EmptyPlaceholderError{ range }));

                // 
                data.complete(input.config, input.index, Option::None, errors)
            }
        }
    }
}

#[derive(Debug, Clone)]
pub struct StringBodyContext {
    pub quote: Option<QuoteContext>,
}

impl StringBodyContext {
    pub fn new() -> StringBodyContext {
        StringBodyContext {
            quote: Option::None,
        }
    }

    pub fn process(
        self, 
        input:&CharacterInput, 
        data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        match self.quote {
            Option::None => {
                self.process_none(input, data, errors)
            }
            Option::Some(quote) => {
                quote.process(input, data, errors)
            }
        }
    }

    pub fn process_none(
        self, 
        input:&CharacterInput, 
        mut data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        let character = input.character;
        match character {
            ' ' | '\t' | '\r' | '\n' | '(' | ')' | '\'' | '\"' | ';' => {
                data.complete_and_process(input, Option::None, errors)
            }

            _ if is_blacklist_whitespace(character) => {
                data.complete_and_process(input, Option::None, errors)
            }

            '$' => {
                let range = Range::with_length(input.index, 1);
                errors.push(ParseError::from(InvalidPlaceholderPositionError{ range }));

                data.content.push(character);
                data.continue_body(self)                
            }

            _ => {
                data.content.push(character);
                data.continue_body(self)
            }
        }
    }
    
    pub fn complete(
        self, 
        input:&EndInput, 
        data:StringData, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ATree<TemplateLeaf> {
        match self.quote {
            Option::None => {
                data.complete(input.config, input.index, Option::None, errors)
            }
            Option::Some(quote) => {
                quote.complete(input, data, errors)
            }
        }
    }
}


fn remove_content_indent(
    start_index: usize,
    mut string:String,
    errors:&mut ErrorWrite<ParseError>
) -> String {
    // 末尾のインデントを取得
    let mut last_indent_stack = String::new();
    loop {
        match string.pop() {
            Option::Some(character) => {
                match character {
                    '\t' | ' ' => {
                        last_indent_stack.push(character);
                    }
                    '\n' => {
                        // 末尾のLFを結果に含めない
                        if let Option::Some(character) = string.pop() {
                            // CRLFで1つの改行とみなす
                            if character != '\r' {
                                // CRでなければ、戻す
                                string.push(character);
                            }
                        }
                        break;
                    }
                    '\r' => {
                        // 末尾のCRを結果に含めない
                        break;
                    }
                    _ => {
                        // インデントではないので、popしたものを戻す。
                        string.push(character);
                        while let Option::Some(character) = last_indent_stack.pop() {
                            string.push(character);
                        }
                        break;
                    }
                }
            }

            Option::None => {
                // 空白のみからなる1行
                // インデントをそのまま返す
                return reverse(last_indent_stack);
            }
        }
    }

    let mut result_stack = String::new();
    let mut newlined = true;
    let indent_len = last_indent_stack.len();
    while let Option::Some(character) = string.pop() {
        match character {
            '\n' | '\r' => {
                if !newlined {
                    // 末尾インデントと同じ長さのインデントを削除
                    let result_len = result_stack.len();
                    let pos = if result_len < indent_len {
                        0
                    } else {
                        result_len - indent_len
                    };
                    let indent_stack = result_stack.split_off(pos);
                    if indent_stack != last_indent_stack {
                        // 末尾のインデントと、各インデントが食い違っていたらエラー
                        let start = start_index + string.len();
                        let range = Range::with_length(start + 1, indent_stack.len());
                        errors.push(ParseError::from(UnmatchedIndentError {range}));

                        // 修復方法：インデントとみなさず、文字列を戻す
                        result_stack.push_str(&indent_stack);
                    }
                }

                newlined = true;
            }
            
            _ => {
                newlined = false;
            }
        }

        result_stack.push(character);
    }

    // 文字列の先頭に対する処理
    let mut first_line = String::new();
    while let Option::Some(character) = result_stack.pop() {
        match character {
            '\t' | ' ' => {
                first_line.push(character);
            }
            '\r' => {
                // 先頭のCRを結果に含めない
                if let Option::Some(character) = result_stack.pop() {
                    // CRLFで1つの改行とみなす
                    if character != '\n' {
                        // CRでなければ、戻す
                        result_stack.push(character);
                    }
                }
                break;
            }
            '\n' => {
                // 先頭のLFを結果に含めない
                break;
            }
            _ => {
                // インデントではないので、popしたものを戻す。
                result_stack.push(character);
                while let Option::Some(character) = first_line.pop() {
                    result_stack.push(character);
                }
                break;
            }
        }
    }
    
    reverse(result_stack)
}

fn reverse(string:String) -> String {
    string.chars().rev().collect()
}
