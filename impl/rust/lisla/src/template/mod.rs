pub mod error;
use self::error::*;
use data::tag::*;
use data::tree::*;
use data::leaf::*;
use ::error::*;

//#[derive(StringNewtype)]
#[derive(Debug, Clone)]
pub struct Placeholder {
    pub key: String,
}

#[derive(Debug, Clone)]
pub enum TemplateLeaf {
    Placeholder(Placeholder),
    String(String),
}

impl TemplateLeaf {
    pub fn complete(self, tag:&Tag) -> Result<String, PlaceholderCompleteError> {
        match self {
            TemplateLeaf::Placeholder(placeholder) => 
                Result::Err(
                    PlaceholderCompleteError {
                        placeholder, 
                        range: tag.content_range.clone()
                    }
                ),

            TemplateLeaf::String(string) => 
                Result::Ok(string),
        }
    }
}

pub struct TemplateConfig {
    // エラーが数がいくつ以下であれば処理を継続するか？
    pub continuous_error_limit: usize,
}

pub struct TemplateProcessor {
    pub config: TemplateConfig,
}

impl TemplateProcessor {
    pub fn new(config: TemplateConfig) -> TemplateProcessor {
        TemplateProcessor { config }
    }

    pub fn complete(
        &self, 
        template:ATreeArrayBranch<TemplateLeaf>, 
        errors:&mut ErrorWrite<PlaceholderCompleteError>
    ) -> Option<ATreeArrayBranch<String>> {
        let mut next = Vec::new();
        for child in template.array {
            let tree = match child {
                ATree::Array(current) => {
                    // 子要素に対する再起
                    if let Option::Some(branch) = self.complete(current, errors) {
                        ATree::Array(branch)
                    } else {
                        return Option::None
                    }
                }

                ATree::Leaf(current) => {
                    // プレースホルダーを閉じる
                    let leaf = match current.leaf.complete(&current.tag) {
                        Result::Ok(ok) => 
                            ok,

                        Result::Err(error) => {
                            // 復帰方法プレースホルダーをそのままの文字列として扱う
                            let string = format!("\\({})", error.placeholder.key);

                            errors.push(error);
                            if errors.len() > self.config.continuous_error_limit {
                                return Option::None;
                            }

                            string
                        }
                    };
                    
                    ATree::Leaf(
                        Leaf { leaf, tag: current.tag }
                    )
                }
            };

            next.push(tree);
        }

        Option::Some(
            ArrayBranch {
                array: next,
                tag: template.tag,
            }
        )
    }
}
