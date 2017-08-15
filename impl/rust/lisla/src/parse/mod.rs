mod array;
pub mod error;
mod escape;
mod space;
mod string;
mod quote;

use data::tag::*;
use data::tree::*;
use data::position::*;
use template::*;
use std::io::{Read, CharsError};
use self::error::*;
use self::array::*;
use self::space::*;
use ::error::*;

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

// タグ情報をどの程度保持するか？
#[derive(Debug, Clone)]
pub enum TagInfomationLevel {
// TODO: 
//   // 以下の情報が保持する
//   // ・Range
//   // ・クオート種別
//   // 
//   // 以下の目的で使用できる
//   // ・通信用途
//   Low,

    // 極力情報を保持する
    // 
    // 以下の情報が保持する
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
    pub fn parse_template(&self, stream:&mut Read) -> ResumableResult<ATreeArrayBranch<TemplateLeaf>, ParseError> {
        let mut errors = Errors::new();
        let tree = self.parse_template_internal(stream, &mut errors);
        ResumableResult::new(tree, errors)
    }

    // ライブラリの内部利用用の、テンプレート形式のlislaをパース。
    // エラーをResultではなく、ErrorWriteで行う。
    pub fn parse_template_internal(&self, stream:&mut Read, errors:&mut ErrorWrite<ParseError>) -> Option<ATreeArrayBranch<TemplateLeaf>> {
        let mut context = ArrayContext::new(ArrayParentKind::Top, 0, Option::None);
        let mut last_index = 0;

        for (index, char_result) in stream.chars().enumerate() {
            let character = match char_result {
                Result::Ok(character) => character,
                
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
                    return Option::None;
                }
            };

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

    // 通常形式のlislaをパースします。
    pub fn parse(&self, stream:&mut Read) -> ResumableResult<ATreeArrayBranch<String>, ParseStringError> {
        let mut errors = Errors::new();
        let tree = self.parse_internal(stream, &mut errors);
        ResumableResult::new(tree, errors)
    }

    // ライブラリの内部利用用の、通常形式のlislaをパース。
    // エラーをResultではなく、ErrorWriteで行う。
    pub fn parse_internal(&self, stream:&mut Read, errors:&mut ErrorWrite<ParseStringError>) -> Option<ATreeArrayBranch<String>> {
        // テンプレートとして、読み込む。
        let mut errors_wrapper = ErrorsWrapper{ errors };
        if let Option::Some(template_tree) = self.parse_template_internal(stream, &mut errors_wrapper) {
            let config = TemplateConfig { 
                continuous_error_limit: self.config.continuous_error_limit 
            };
            let template_processor = TemplateProcessor::new(config);
            template_processor.complete(template_tree, &mut errors_wrapper)
        } else {
            Option::None
        }
    }
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
