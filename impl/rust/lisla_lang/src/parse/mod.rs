mod array;
pub mod error;
mod space;
mod string;
mod quote;

use tree::*;
use data::position::*;
use template::*;
use std::io::{Read, CharsError};
use self::error::*;
use self::array::*;
use self::space::*;
use ::error::*;
use tag::*;
use leaf::*;

#[derive(Debug, Clone)]
pub struct Parser {
    pub config:ParseConfig,
}

#[derive(Debug, Clone)]
pub struct ParseConfig {
    // 各文字を入力した後に、エラーが数がいくつ以下であれば処理を継続するか？
    pub continuous_error_limit: usize,

    // タグ情報をどの程度保持するか？
    pub tag_infomation: TagInfomationLevel,
}

impl ParseConfig {
    pub fn new() -> ParseConfig {
        return ParseConfig {
            continuous_error_limit: ::std::usize::MAX,
            tag_infomation: TagInfomationLevel::All,
        }
    } 

    pub fn into_parser(self) -> Parser {
        Parser {
            config: self
        }
    } 
}

// タグ情報をどの程度保持するか？
#[derive(Debug, Clone)]
pub enum TagInfomationLevel {
   // 以下の情報が保持する
   // ・Range
   // 
   // 以下の目的で使用できる
   // ・通信用途
   Low,

    // 極力情報を保持する
    // 
    // 以下の情報が保持する
    // ・クオート種別
    // ・RAW文字列
    // ・コメント
    // ・空白文字
    // 
    // 以下の目的で使用できる
    // ・エディタ補助（フォーマット、シンタックスハイライト、入力補完）
    All,
}

impl Parser {
    pub fn new() -> Parser {
        return Parser {
            config: ParseConfig {
                continuous_error_limit: ::std::usize::MAX,
                tag_infomation: TagInfomationLevel::All,
            }
        }
    } 

    // テンプレート形式のlislaをパースします。
    pub fn parse_template_from_read(&self, read:&mut Read) -> ResumableResult<WithTag<ArrayBranch<WithTag<ArrayTree<TemplateLeaf>>>>, ParseError> {
        let mut errors = Errors::new();
        match read_to_string(read, &mut errors) {
            Result::Ok(string) => {
                let tree = self.parse_template_internal(&string, &mut errors);
                ResumableResult::new(tree, errors)
            }
            Result::Err(_) => ResumableResult::new(Option::None, errors),
        }
    }

    pub fn parse_template<'a>(&self, string:&'a str) -> ResumableResult<WithTag<ArrayBranch<WithTag<ArrayTree<TemplateLeaf>>>>, ParseError> {
        let mut errors = Errors::new();
        let tree = self.parse_template_internal(string, &mut errors);
        ResumableResult::new(tree, errors)
    }

    // ライブラリの内部利用用の、テンプレート形式のlislaをパース。
    // エラーをResultではなく、ErrorWriteで行う。
    pub fn parse_template_internal<'a>(&self, input:&'a str, errors:&mut ErrorWrite<ParseError>) -> Option<WithTag<ArrayBranch<WithTag<ArrayTree<TemplateLeaf>>>>> {
        let mut context = ArrayContext::new(ArrayParentKind::Top, 0, Option::None);
        let mut last_index = 0;
        
        for (index, character) in input.chars().enumerate() {
            // 1文字ごとに、process関数に流し込む
            let input = CharacterInput {
                config: &self.config,
                index,
                character,
            };
            context = context.process(&input, errors);

            // エラー数が許容値を超えていれば中断
            if errors.len() > self.config.continuous_error_limit {
                return Option::None;
            }

            last_index = index;
        }

        let tree = context.complete(
            &EndInput{
                config: &self.config,
                index: last_index + 1,
            }, 
            errors
        );

        Option::Some(tree)
    }

    // lislaをパースします。
    // placeholderが残っている場合、エラーになります。
    pub fn parse_from_read(&self, read:&mut Read) -> ResumableResult<WithTag<ArrayBranch<WithTag<ArrayTree<StringLeaf>>>>, ParseStringError> {
        let mut errors = Errors::new();
        let result = {
            let mut errors_wrapper = ErrorsWrapper{ errors: &mut errors };
            read_to_string(read, &mut errors_wrapper)
        };
        
        match result {
            Result::Ok(string) => {
                let tree = self.parse_internal(&string, &mut errors);
                ResumableResult::new(tree, errors)
            }
            Result::Err(_) => {
                ResumableResult::new(Option::None, errors)   
            }
        }
    }

    pub fn parse<'a>(&self, string:&'a str) -> ResumableResult<WithTag<ArrayBranch<WithTag<ArrayTree<StringLeaf>>>>, ParseStringError> {
        let mut errors = Errors::new();
        let tree = self.parse_internal(string, &mut errors);
        ResumableResult::new(tree, errors)
    }

    // ライブラリの内部利用用の、通常形式のlislaをパース。
    // エラーをResultではなく、ErrorWriteで行う。
    pub fn parse_internal<'a>(&self, input:&'a str, errors:&mut ErrorWrite<ParseStringError>) -> Option<WithTag<ArrayBranch<WithTag<ArrayTree<StringLeaf>>>>> {
        // テンプレートとして、読み込む。
        let mut errors_wrapper = ErrorsWrapper{ errors };
        if let Option::Some(template_tree) = self.parse_template_internal(input, &mut errors_wrapper) {
            let config = TemplateConfig { 
                continuous_error_limit: self.config.continuous_error_limit 
            };
            let template_processor = TemplateProcessor::new(config);
            
            template_processor.array_complete(template_tree, &mut errors_wrapper)
        } else {
            Option::None
        }
    }
}

fn read_to_string(stream:&mut Read, errors:&mut ErrorWrite<ParseError>) -> Result<String, ()> {
    let mut string = String::new();
    for (index, char_result) in stream.chars().enumerate() {
        match char_result {
            Result::Ok(character) => string.push(character),
            Result::Err(char_error) => {
                // IOエラーまたは、不正なUTF8
                let range = Range::with_length(index, 1);
                let error = match char_error {
                    CharsError::NotUtf8 => 
                        ParseError::from(
                            NotUtf8Error { range }
                        ),

                    CharsError::Other(error) => {
                        let reason = IoErrorReason{ error };
                        ParseError::from(
                            IoError { range, reason }
                        )
                    }
                };
                errors.push(error);

                // 修復しない。
                return Result::Err(());
            }
        }
    }
    Result::Ok(string)
}

pub struct CharacterInput<'a> {
    pub config: &'a ParseConfig,
    pub character: char,
    pub index: usize,
}

pub struct EndInput<'a> {
    pub config: &'a ParseConfig,
    pub index: usize,
}
