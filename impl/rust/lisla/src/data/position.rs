use std::fmt::{self, Display};

pub trait Position {
    fn range(&self)->Option<&Range>;
    fn source_map(&self)->Option<&SourceMap>;
    fn file_path(&self)->Option<&FilePathFromProjectRoot>;
    fn project_root(&self)->Option<&ProjectRootPath>;

    fn position_string(&self) -> String {
        let result = format!(
            "{}:{}",
            match (self.project_root(), self.file_path()) {
                (Option::Some(project_root), Option::Some(file_path)) =>
                    format!("{}/{}", project_root.value, file_path.value),
                
                (Option::None, Option::Some(file_path)) =>
                    format!("project_root://{}", file_path.value),
                
                (Option::Some(project_root), Option::None) =>
                    format!("{}/**", project_root.value),
                
                (Option::None, Option::None) =>
                    "**".to_string(),
            },
            match (self.source_map(), self.range()) {
                (Option::Some(source_map), Option::Some(range)) =>
                    format!("{}", source_map.local(&range)),
                    
                (Option::None, Option::Some(range)) =>
                    format!("{}", range),
                    
                (Option::Some(source_map), Option::None) =>
                    format!("{}", source_map),
                    
                (Option::None, Option::None) =>
                    "".to_string(),
            }
        );

        result
    }
}

#[derive(Debug, Clone, Ord, Eq, PartialEq, PartialOrd)]
pub struct Range {
    start:usize,
    length:usize,
}

impl Range {
    pub fn start(&self)->usize { self.start }
    pub fn len(&self)->usize { self.length }
    pub fn end(&self)->usize { self.start + self.length }

    pub fn with_end(start:usize, end:usize) -> Range {
        Range { start, length: end - start }
    }
    
    pub fn with_length(start:usize, length:usize) -> Range {
        Range { start, length }
    }
}

impl Display for Range {
    fn fmt(&self, formatter: &mut fmt::Formatter) -> Result<(), fmt::Error> {
        write!(
            formatter, 
            "{}-{}",
            self.start(),
            self.end(),
        );
        
        Result::Ok(())
    }
}

#[derive(Debug, Clone)]
pub struct SourceMap {
    pub ranges: Vec<SourceRange>,
}

impl SourceMap {
    pub fn new() -> SourceMap {
        SourceMap { ranges:Vec::new() }
    }

    pub fn local(&self, local_range:&Range) -> SourceMap {
        let mut result = SourceMap::new();

        let mut local_start = local_range.start();
        let start_index = match self.ranges.binary_search_by(|range| range.inner_start.cmp(&local_start)) {
            Result::Ok(index)  => index,
            Result::Err(0)     => 0,
            Result::Err(index) => index - 1,
        };

        let local_end = local_range.end();

        for index in start_index..self.ranges.len() {
            let range = &self.ranges[index];
            let mut inner_start = local_start - range.inner_start;
            
            if range.range.end() < local_end {
                result.add_range(
                    range.range.start + local_start,
                    range.range.end(),
                );
            } else {
                result.add_range(
                    range.range.start + local_start, 
                    range.range.start + local_end,
                );
                break;
            }
        }

        result
    }

    pub fn add_range(&mut self, start:usize, end:usize) {
        let range = Range::with_end(start, end);
        let inner_start = if let Option::Some(ref last_range) = self.ranges.last() {
            last_range.inner_end()
        } else {
            0
        };
        self.ranges.push(SourceRange{ inner_start, range });
    }
}

impl Display for SourceMap {
    fn fmt(&self, formatter: &mut fmt::Formatter) -> Result<(), fmt::Error> {
        for range in &self.ranges {
            range.range.fmt(formatter);
        }
        Result::Ok(())
    }
}

#[derive(Debug, Clone)]
pub struct SourceRange { 
    pub inner_start: usize,
    pub range: Range,
} 

impl SourceRange {
    pub fn inner_end(&self) -> usize {
        self.inner_start + self.range.len()
    }
}

//#[derive(Debug, Newtype)]
pub struct FilePathFromProjectRoot {
    pub value: String
}

//#[derive(Debug, Newtype)]
pub struct ProjectRootPath {
    pub value: String
}
