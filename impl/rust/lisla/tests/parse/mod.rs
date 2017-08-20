
use std::fs;
use std::io::Read;
use serde_json::Value;
use serde_json;
use lisla_lang::parse::*;
use lisla_lang::data::tree::*;

const TEST_CASES_PATH: &'static str = "./../../../data/test_case/lisla/";

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
        let mut into_iter = case_data.array.into_iter();

        let lisla_string = into_iter.next().unwrap().to_leaf().unwrap().leaf;
        let json_string = into_iter.next().unwrap().to_leaf().unwrap().leaf;
        let lisla_data = parser.parse(&lisla_string).unwrap();
        let json_data = serde_json::from_str(json_string.as_str()).unwrap();

        equals(&ATree::Array(lisla_data),
               &json_data,
               entry.path().to_str().unwrap(),
               &mut vec![]);
    }
}

fn equals(lisla: &ATree<String>, json: &Value, path: &str, stack: &mut Vec<usize>) {
    match (lisla, json) {
        (&ATree::Array(ref s), &Value::Array(ref j)) => {
            assert!(s.array.len() == j.len(),
                    "unmatched array length({}:{:?}): {:?} {:?}",
                    path,
                    stack,
                    s.array.len(),
                    j.len());

            for (i, (sc, jc)) in s.array.iter().zip(j.iter()).enumerate() {
                stack.push(i);
                equals(sc, jc, path, stack);
                stack.pop();
            }
        }

        (&ATree::Leaf(ref s), &Value::String(ref j)) => {
            assert!(s.leaf.as_str() == j.as_str(),
                    "unmatched string({}:{:?}): {:?} {:?}",
                    path,
                    stack,
                    s.leaf,
                    j);
        }

        (_, _) => {
            panic!("unmatched({}:{:?}): {:?} {:?}", path, stack, lisla, json);
        }
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
