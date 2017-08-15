use data::tag::*;
use super::error::ParseError;
use super::*;
use super::string::*;
use super::array::*;

#[derive(Debug, Clone)]
pub struct SpaceContext {
    data: SpaceData,
    kind: SpaceContextKind,
}

impl SpaceContext {
    pub fn new(start:usize) -> SpaceContext {
        SpaceContext {
            data: SpaceData::new(start),
            kind: SpaceContextKind::Normal(NormalContext::new(start)),
        }
    }

    // 1文字入力して、次の状態遷移を返す
    pub fn process(self, input:&CharacterInput, errors:&mut ErrorWrite<ParseError>) -> ProcessAction {
        match self.kind {
            SpaceContextKind::Normal(context) => 
                self.data.process_normal(input, context, errors),

            SpaceContextKind::Comment(context) => 
                self.data.process_comment(input, context),
        }
    }

    // ファイルの末尾まで来たので、スペースを生成してこの文脈を終了
    pub fn complete(self, input:&EndInput, errors:&mut ErrorWrite<ParseError>) -> Option<Space> {
        match self.kind {
            SpaceContextKind::Normal(context) => 
                self.data.complete_normal(input.config, input.index, context),

            SpaceContextKind::Comment(context) => 
                self.data.complete_comment(input.config, input.index, context),
        }
    }
}

#[derive(Debug, Clone)]
struct SpaceData {
    start: usize,
    lines: Vec<SpaceLine>,
}

impl SpaceData {
    pub fn new(start:usize) -> SpaceData {
        SpaceData {
            start,
            lines: Vec::new(),
        }
    }

    fn process_normal(
        self, 
        input:&CharacterInput, 
        mut normal_context: NormalContext,
        errors:&mut ErrorWrite<ParseError>
    ) -> ProcessAction {
        let character = input.character;
        match character {
            '[' => {
                let space = self.complete_normal(input.config, input.index, normal_context);
                ProcessAction::OpenArray{ space }
            }

            ']' => {
                let space = self.complete_normal(input.config, input.index, normal_context);
                ProcessAction::CloseArray{ space }
            }

            '#' => {
                let comment_context = normal_context.into_comment();
                self.space_action(SpaceContextKind::Comment(comment_context))
            }

            ' ' | '\t' => {
                normal_context.add(input.character);
                self.space_action(SpaceContextKind::Normal(normal_context))
            }

            '\r' => {
                normal_context.add(input.character);
                self.space_action(SpaceContextKind::Normal(normal_context))
            }

            '\n' => {
                normal_context.add(input.character);
                self.space_action(SpaceContextKind::Normal(normal_context))
            }

            _ if is_blacklist_whitespace(character) => {
                let range = Range::with_length(input.index, 1);
                errors.push(ParseError::from(BlacklistedWhiteSpaceError{ range, character }));
                normal_context.add(input.character);
                self.space_action(SpaceContextKind::Normal(normal_context))
            }

            _ => {
                let space = self.complete_normal(input.config, input.index, normal_context);
                StringContext::process_first_character(input, space, errors)
            } 
        }
    }

    fn space_action(self, kind: SpaceContextKind) -> ProcessAction {
        ProcessAction::Next(
            ArrayContextKind::Space(
                SpaceContext {
                    data: self,
                    kind
                }
            )
        )
    }

    fn process_comment(mut self, input:&CharacterInput, mut comment_context: CommentContext) -> ProcessAction {
        let character = input.character;
        let kind = match character {
            '#' if comment_context.is_head && !comment_context.comment.is_document => {
                comment_context.comment.is_document = true;
                SpaceContextKind::Comment(comment_context)
            }
            '!' if comment_context.is_head => {
                comment_context.is_head = true;
                SpaceContextKind::Comment(comment_context)
            }
            '\r' => {
                self.lines.push(comment_context.complete(input.index, Option::Some(NewlineKind::Cr)));
                SpaceContextKind::Normal(NormalContext::new(input.index))
            }
            '\n' => {
                self.lines.push(comment_context.complete(input.index, Option::Some(NewlineKind::Lf)));
                SpaceContextKind::Normal(NormalContext::new(input.index))
            }
            _ => {
                comment_context.add(character);
                SpaceContextKind::Comment(comment_context)
            }
        };

        ProcessAction::Next(
            ArrayContextKind::Space(
                SpaceContext {
                    data: self,
                    kind
                }
            )
        )
    }
    
    fn complete_normal(mut self, config:&ParseConfig, index:usize, normal_context:NormalContext) -> Option<Space> {
        self.lines.push(normal_context.complete(index, Option::None));
        Option::Some(
            Space {
                range: Range::with_end(self.start, index),
                lines: self.lines,
            }
        )
    }

    fn complete_comment(mut self, config:&ParseConfig, index:usize, comment_context:CommentContext) -> Option<Space> {
        self.lines.push(comment_context.complete(index, Option::None));
        Option::Some(
            Space {
                range: Range::with_end(self.start, index),
                lines: self.lines,
            }
        )
    }
}

#[derive(Debug, Clone)]
enum SpaceContextKind {
    Normal(NormalContext),
    Comment(CommentContext),
}

#[derive(Debug, Clone)]
struct NormalContext {
    line_start: usize,
    indent: String,
}

impl NormalContext {
    fn new(line_start:usize) -> NormalContext {
        NormalContext{ 
            line_start,
            indent: String::new(),
        }
    }

    fn complete(self, line_end:usize, newline:Option<NewlineKind>) -> SpaceLine {
        SpaceLine {
            range: Range::with_end(self.line_start, line_end),
            indent: self.indent,
            comment: Option::None,
            newline
        }
    }
    
    fn add(&mut self, character:char) {
        self.indent.push(character);
    }

    fn into_comment(self) -> CommentContext {
        CommentContext {
            is_head: true,
            line_start: self.line_start,
            indent: self.indent,
            comment: Comment::new(),
        }
    }
}

#[derive(Debug, Clone)]
struct CommentContext {
    line_start: usize,
    is_head: bool,
    indent: String,
    comment: Comment,
}

impl CommentContext {
    fn complete(self, line_end:usize, newline:Option<NewlineKind>) -> SpaceLine {
        SpaceLine {
            range: Range::with_end(self.line_start, line_end),
            indent: self.indent,
            comment: Option::Some(self.comment),
            newline
        }
    }

    fn add(&mut self, character:char) {
        self.comment.content.push(character);
    }
}

pub fn is_blacklist_whitespace(character: char) -> bool {
    match character {
        '\u{000B}' |
        '\u{000C}' |
        '\u{0085}' |
        '\u{00A0}' |
        '\u{1680}' |
        '\u{2000}'...'\u{200A}' |
        '\u{2028}' |
        '\u{2029}' |
        '\u{202F}' |
        '\u{205F}' |
        '\u{3000}' => true,
        _ => false,
    }
}
