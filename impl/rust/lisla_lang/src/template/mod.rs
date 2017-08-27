pub mod error;
use self::error::*;
use tag::*;
use tree::*;
use ::error::*;
use leaf::*;

//#[derive(StringNewtype)]
#[derive(Debug, Clone, Eq, PartialEq)]
pub struct Placeholder {
    pub key: String,
}

#[derive(Debug, Clone, Eq, PartialEq)]
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

impl Leaf for TemplateLeaf {
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

    pub fn array_complete(
        &self, 
        template: WithTag<ArrayBranch<WithTag<ArrayTree<TemplateLeaf>>>>,
        errors:&mut ErrorWrite<PlaceholderCompleteError>
    ) -> Option<WithTag<ArrayBranch<WithTag<ArrayTree<StringLeaf>>>>> {
        let mut vec = Vec::new();
        for child in template.data.vec {
            // 子要素に対する再起
            if let Option::Some(tree) = self.complete(child, errors) {
                vec.push(tree);
            } else {
                return Option::None
            }
        }

        Option::Some(
            WithTag {
                data: ArrayBranch { vec },
                tag: template.tag,
            }
        )
    }

    pub fn complete(
        &self, 
        template: WithTag<ArrayTree<TemplateLeaf>>,
        errors:&mut ErrorWrite<PlaceholderCompleteError>
    ) -> Option<WithTag<ArrayTree<StringLeaf>>> {
        let data = match template.data {
            ArrayTree::Array(current) => {
                let mut next = Vec::new();
                for child in current.vec {
                    // 子要素に対する再起
                    if let Option::Some(tree) = self.complete(child, errors) {
                        next.push(tree);
                    } else {
                        return Option::None
                    }
                }
                ArrayTree::Array(ArrayBranch { vec:next })
            }

            ArrayTree::Leaf(current) => {
                // プレースホルダーを閉じる
                let string = match current.complete(&template.tag) {
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

                ArrayTree::Leaf(StringLeaf{ string })
            }
        };

        Option::Some(
            WithTag { 
                data,
                tag: template.tag
            }
        )
    }
}
