use super::error::ParseError;
use super::*;
use super::space::*;
use super::string::*;
use data::tag::*;
use data::position::*;

#[derive(Debug, Clone)]
pub struct ArrayContext {
    data: ArrayData,
    kind: ArrayContextKind,
}

#[derive(Debug, Clone)]
pub enum ArrayParentKind {
    Top,
    Array(Box<ArrayData>),
}

#[derive(Debug, Clone)]
pub enum ArrayContextKind {
    Space(SpaceContext),
    String(StringContext),
}

impl ArrayContext {
    pub fn new(
        parent: ArrayParentKind,
        start:usize, 
        leading_space:Option<Space>, 
    ) -> ArrayContext {
        let space_start = match parent {
            ArrayParentKind::Array(_) => start + 1,
            ArrayParentKind::Top => start,
        };
        ArrayContext {
            data: ArrayData {
                parent, 
                detail: ArrayDetail {
                    start,
                    leading_space,
                    elements: Vec::new(),
                }
            },
            kind: ArrayContextKind::Space(SpaceContext::new(space_start)),
        }
    }

    pub fn process(self, input:&CharacterInput, errors:&mut ErrorWrite<ParseError>) -> ArrayContext {
        let action = match self.kind {
            ArrayContextKind::Space(context) => {
                // 空白の文脈での処理
                context.process(input, errors)
            }

            ArrayContextKind::String(context) => {
                // 文字列の文脈での処理
                context.process(input, errors)
            }
        };

        self.data.do_action(input, action, errors)
    }

    // 入力の終了
    pub fn complete(mut self, input:&EndInput, errors:&mut ErrorWrite<ParseError>) -> ATreeArrayBranch<TemplateLeaf> {
        let footer_space = match self.kind {
            ArrayContextKind::Space(context) => 
                context.complete(input),

            ArrayContextKind::String(context) => {
                let tree = context.complete(input, errors);
                self.data.detail.elements.push(tree);
                SpaceContext::new(input.index).complete(input)
            }
        };

        self.data.complete(input, footer_space, errors)
    }
}

#[derive(Debug, Clone)]
pub struct ArrayData {
    parent: ArrayParentKind,
    detail: ArrayDetail, 
}

impl ArrayData {

    fn do_action(
        mut self, 
        input:&CharacterInput, 
        action:ProcessAction, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ArrayContext {
        match action {
            ProcessAction::Next(kind) => {
                ArrayContext{
                    kind,
                    data: self
                }
            }

            ProcessAction::OpenArray{ space } => 
                self.open_array(input, space),

            ProcessAction::CloseArray{ space } => 
                self.close_array(input, space, errors),

            ProcessAction::Add{ element, action } => {
                self.detail.elements.push(element);
                self.do_action(input, *action, errors)
            }
        }
    }

    // `]`に対する処理。Arrayを1つ閉じる。
    fn close_array(
        self, 
        input:&CharacterInput, 
        footer_space:Option<Space>, 
        errors:&mut ErrorWrite<ParseError>
    ) -> ArrayContext {
        let data = match self.parent {
            ArrayParentKind::Array(mut data) => {
                let tree = ATree::Array(self.detail.complete(input.config, input.index, footer_space));
                data.detail.elements.push(tree);
                *data
            }
            
            ArrayParentKind::Top => {
                // 対応する開始`[`がない
                let range = Range::with_length(input.index, 0);
                errors.push(ParseError::from(TooManyClosingBracketsError{ range }));

                // 修復方法：この閉じカッコを、インデントとみなす。
                if let Option::Some(mut s) = footer_space {
                    s.add_indent(input.character)
                }

                self
            }
        };
        
        ArrayContext {
            kind: ArrayContextKind::Space(SpaceContext::new(input.index)),
            data: data,
        }
    }
    
    // `[`に対する処理。Arrayを1つ開く。
    fn open_array(self, input:&CharacterInput, leading_space:Option<Space>) -> ArrayContext {
        ArrayContext::new(
            ArrayParentKind::Array(Box::new(self)),
            input.index,
            leading_space
        )
    }
    
    fn complete(
        self, 
        input:&EndInput, 
        footer_space:Option<Space>, 
        errors:&mut ErrorWrite<ParseError>) -> ATreeArrayBranch<TemplateLeaf> 
    {
        let start = self.detail.start;
        let branch = self.detail.complete(input.config, input.index, footer_space);

        match self.parent {
            ArrayParentKind::Array(mut data) => {
                // ')'が無い
                let range = Range::with_length(start, 1);
                errors.push(ParseError::from(UnclosedArrayError { range }));

                // ここで、配列を閉じる
                let tree = ATree::Array(branch);
                data.detail.elements.push(tree);
                let footer_space = SpaceContext::new(input.index).complete(input);

                data.complete(input, footer_space, errors)
            }
            
            ArrayParentKind::Top => {
                branch
            }
        }
    }
}

#[derive(Debug, Clone)]
pub struct ArrayDetail {
    start: usize,
    leading_space: Option<Space>,
    elements: Vec<ATree<TemplateLeaf>>,
}

impl ArrayDetail {
    fn complete(
        self,
        config: &ParseConfig,
        end_index:usize, 
        footer_space:Option<Space>) -> ATreeArrayBranch<TemplateLeaf> 
    {
        let tag_kind = TagKind::Array(
            ArrayTag {
                footer_space,
            }
        );

        ArrayBranch {
            array: self.elements,
            tag: Tag::new(
                self.leading_space, 
                Range::with_end(self.start, end_index),
                Option::Some(tag_kind)
            )
        }
    }
}

// 1文字入力時に発生する状態遷移
#[derive(Debug, Clone)]
pub enum ProcessAction {
    Add{
        element: ATree<TemplateLeaf>, 
        action: Box<ProcessAction>,
    },
    Next(ArrayContextKind),
    CloseArray { space: Option<Space>, },
    OpenArray { space: Option<Space>, },
}
