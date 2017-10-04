
use std::fs;
use std::io::Read;
use serde_json;
use arraytree_lang::parse::*;

const TEST_CASES_PATH: &'static str = "./../../../data/test_case/arraytree/";

#[test]
fn test_basic() {
    let path = format!("{}{}", TEST_CASES_PATH, "basic");
    let dir = fs::read_dir(path).unwrap();
    let parser = Parser::new();

    for result in dir {
        let entry = result.unwrap();
        let metadata = entry.metadata().unwrap();
        if metadata.is_dir() {
            continue;
        }

        let mut file = fs::File::open(entry.path()).unwrap();
        let mut string = String::new();
        file.read_to_string(&mut string).unwrap();

        let case_data = parser.parse(&mut string).unwrap();
        let mut into_iter = case_data.data.vec.into_iter();

        let arraytree_string = into_iter.next().unwrap().data.to_leaf().unwrap().string;
        let json_string = into_iter.next().unwrap().data.to_leaf().unwrap().string;
        let arraytree_data = parser.parse(&arraytree_string).unwrap();
        let json_data = serde_json::from_str(json_string.as_str()).unwrap();

        ::equals(&arraytree_data.into(),
               &json_data,
               entry.path().to_str().unwrap(),
               &mut vec![]);
    }
}


#[test]
fn test_invalid_nonfatal() {
    let path = format!("{}{}", TEST_CASES_PATH, "advanced/invalid/nonfatal");
    let dir = fs::read_dir(path).unwrap();
    let parser = Parser::new();

    for result in dir {
        let entry = result.unwrap();
        let metadata = entry.metadata().unwrap();
        if metadata.is_dir() {
            continue;
        }

        let path = entry.path();
        let name = String::from(path.to_str().unwrap());
        let mut file = fs::File::open(path).unwrap();
        let mut string = String::new();
        file.read_to_string(&mut string).unwrap();
        let result = parser.parse(&string).to_result();

        match result {
            Ok(data) => {
                panic!("data: {} : {:?}", name, data);
            }
            Err(_) => {}
        }
    }
}
