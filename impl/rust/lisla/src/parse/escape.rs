use data::tag::*;
use data::position::*;
use super::*;
use super::string::*;
use super::array::*;
use std::char;
use std::u32;

#[derive(Debug, Clone)]
pub enum EscapeContext {
    Top,
    Unicode(UnicodeEscapeContext),
    Placeholder(PlaceholderContext)
}

impl EscapeContext {
    pub fn process(
        self, 
        input:&CharacterInput, 
        errors:&mut ErrorWrite<ParseError>
    ) -> EscapeAction {
        match self {
            EscapeContext::Top => {
                match input.character {
                    'u' => {
                        let context = UnicodeEscapeContext::new(input.index - 1);
                        EscapeAction::Continue(EscapeContext::Unicode(context))
                    }
                    
                    '('  => {
                        let context = PlaceholderContext::new(input.index - 1);
                        EscapeAction::Continue(EscapeContext::Placeholder(context))
                    }

                    'n'  => EscapeAction::End(Option::Some('\n')),
                    'r'  => EscapeAction::End(Option::Some('\r')),
                    't'  => EscapeAction::End(Option::Some('\t')),
                    '0'  => EscapeAction::End(Option::Some('\0')),
                    '\\' => EscapeAction::End(Option::Some('\\')),
                    '\'' => EscapeAction::End(Option::Some('\'')),
                    '\"' => EscapeAction::End(Option::Some('\"')),
                    

                    _ => {
                        // 不正なエスケープ
                        let range = Range::with_length(input.index - 1, input.index + 1);
                        errors.push(ParseError::from(InvalidEscapeError{ range }));
                        
                        EscapeAction::End(Option::None)
                    } 
                }
            }

            EscapeContext::Unicode(context) => {
                context.process(input, errors)
            }
            
            EscapeContext::Placeholder(context) => {
                context.process(input, errors)
            }
        }
    }
}

#[derive(Debug, Clone)]
pub struct UnicodeEscapeContext {
    start: usize,
    data: Option<String>
}

impl UnicodeEscapeContext {
    pub fn new(start:usize) -> UnicodeEscapeContext {
        UnicodeEscapeContext {
            start,
            data: Option::None,
        }
    }

    pub fn process(
        mut self, 
        input:&CharacterInput, 
        errors:&mut ErrorWrite<ParseError>
    ) -> EscapeAction {
        let character = input.character;
        if let Option::Some(mut string) = self.data {
            match character {
                '0'...'9' | 'A'...'F' | 'a'...'f' => {
                    string.push(character);
                    let next = UnicodeEscapeContext {
                        start: self.start,
                        data: Option::Some(string)
                    };
                    EscapeAction::Continue(EscapeContext::Unicode(next))
                }

                '}' => {
                    let len = string.len();
                    if len < 1 || 6 < len {
                        // 不正なユニコードの桁数
                        let range = Range::with_end(self.start, input.index + 1);
                        errors.push(ParseError::from(InvalidUnicodeDigitError{ range }));
                        
                        EscapeAction::End(Option::None)
                    } else {
                        let code = u32::from_str_radix(&string, 16).unwrap();
                        let character = char::from_u32(code);

                        if let Option::None = character {
                            // 不正なユニコード
                            let range = Range::with_end(self.start, input.index + 1);
                            errors.push(ParseError::from(InvalidUnicodeError{ range }));
                        }

                        EscapeAction::End(character)
                    }
                }

                _ => {
                    // 不正なエスケープシークエンス
                    let range = Range::with_end(self.start, input.index + 1);
                    errors.push(ParseError::from(InvalidEscapeError{ range }));

                    // 復帰方法: このエスケープがふくむ文字を無視する
                    EscapeAction::End(Option::None)
                }
            }
        } else {
            match character {
                '{' => {
                    self.data = Option::Some(String::new());
                    EscapeAction::Continue(EscapeContext::Unicode(self))
                }

                _ => {
                    // 不正なエスケープシークエンス
                    let range = Range::with_end(self.start, input.index + 1);
                    errors.push(ParseError::from(InvalidEscapeError{ range }));

                    // 復帰方法: このエスケープがふくむ文字を無視する
                    EscapeAction::End(Option::None)
                }
            }
        }
    }
}

pub enum EscapeAction {
    Continue(EscapeContext),
    End(Option<char>),
    Placeholder(Placeholder),
}

#[derive(Debug, Clone)]
pub struct PlaceholderContext {
    start: usize,
    string: String,
}

impl PlaceholderContext {
    pub fn new(start:usize) -> PlaceholderContext {
        PlaceholderContext {
            start,
            string: String::new(),
        }
    }

    pub fn process(
        mut self, 
        input:&CharacterInput, 
        errors:&mut ErrorWrite<ParseError>
    ) -> EscapeAction {
        let character = input.character;
        match character {
            ')' => {
                let placeholder = Placeholder { string: self.string };
                EscapeAction::Placeholder(placeholder)
            }
            
            '\\' => {
                // 不正なエスケープシークエンス
                let range = Range::with_end(self.start, input.index + 1);
                errors.push(ParseError::from(InvalidEscapeError{ range }));

                // 復帰方法: \\をただの文字列として追加
                self.string.push(character);
                EscapeAction::Continue(EscapeContext::Placeholder(self))
            }

            _ => {
                self.string.push(character);
                EscapeAction::Continue(EscapeContext::Placeholder(self))
            }
        }
    }
}
