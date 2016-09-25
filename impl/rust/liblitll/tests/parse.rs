extern crate liblitll;
extern crate rustc_serialize;

use liblitll::litll::*;

use std::fs;
use std::io::Read;
use rustc_serialize::json::Json;


const TEST_CASES_PATH: &'static str = "./../../../spec/litll/test_case/";

#[test]
fn test_basic() {
    let path = format!("{}{}", TEST_CASES_PATH, "basic");
    let dir = fs::read_dir(path).unwrap();
    let mut config = parse::Config::new();
    config.is_persevering = true;

    for result in dir {
        let entry = result.unwrap();
        let metadata = entry.metadata().unwrap();
        if metadata.is_dir() {
            continue;
        }

        let mut file = fs::File::open(entry.path()).unwrap();
        let mut string = String::new();
        file.read_to_string(&mut string).unwrap();

        let case_data = parse::parse(string.chars(), &config).unwrap();
        let mut into_iter = case_data.data.into_iter();

        let litll_string = into_iter.next().unwrap().str().unwrap();
        let json_string = into_iter.next().unwrap().str().unwrap();
        let litll_data = parse::parse(litll_string.chars(), &config).unwrap();
        let json_data = Json::from_str(json_string.as_str()).unwrap();

        equals(&Litll::Array(litll_data),
               &json_data,
               entry.path().to_str().unwrap(),
               &mut vec![]);
    }
}

fn equals(litll: &Litll, json: &Json, path: &str, stack: &mut Vec<usize>) {
    match (litll, json) {
        (&Litll::Array(ref s), &Json::Array(ref j)) => {
            assert!(s.data.len() == j.len(),
                    "unmatched array length({}:{:?}): {:?} {:?}",
                    path,
                    stack,
                    s.data.len(),
                    j.len());

            for (i, (sc, jc)) in s.data.iter().zip(j.iter()).enumerate() {
                stack.push(i);
                equals(sc, jc, path, stack);
                stack.pop();
            }
        }

        (&Litll::String(ref s), &Json::String(ref j)) => {
            assert!(s.data.as_str() == j.as_str(),
                    "unmatched string({}:{:?}): {:?} {:?}",
                    path,
                    stack,
                    s.data,
                    j);
        }

        (_, _) => {
            panic!("unmatched({}:{:?}): {:?} {:?}", path, stack, litll, json);
        }
    }
}

#[test]
fn test_invalid_nonfatal() {
    let path = format!("{}{}", TEST_CASES_PATH, "advanced/invalid/nonfatal");
    let dir = fs::read_dir(path).unwrap();
    let mut config = parse::Config::new();
    config.is_persevering = true;

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
        let result = parse::parse(string.chars(), &config);

        match result {
            Ok(data) => {
                panic!("data: {} : {:?}", name, data);
            }
            Err(_) => {}
        }
    }
}
