extern crate libsora;
use libsora::sora::parse;

use std::fs;
use std::io::Read;

const TEST_CASES_PATH: &'static str = "./../../../spec/sora/test_case/";

#[test]
fn test_basic() {
    let path = format!("{}{}", TEST_CASES_PATH, "basic");
    let dir = fs::read_dir(path).unwrap();
    let mut config = parse::Config::new();
    config.is_persevering = true;

    for result in dir {
        let entry = result.unwrap();
        let mut file = fs::File::open(entry.path()).unwrap();
        let mut string = String::new();
        file.read_to_string(&mut string).unwrap();

        match parse::parse(string.chars(), &config) {
            Ok(data) => {
                let mut into_iter = data.data.into_iter();
                let inner_string = into_iter.next().unwrap().str().unwrap();
                let json_string = into_iter.next().unwrap().str().unwrap();

                println!("Sora: {}", inner_string);
                println!("Json: {}", json_string);

                match parse::parse(inner_string.chars(), &config) {
                    Ok(data) => {
                        println!("Parsed Data: {:?}", data);
                    }
                    Err(err) => {
                        panic!("Error: {:?}", err);
                    }
                }
            }

            Err(err) => {
                panic!("Error: {:?}", err);
            }
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
            Err(err) => {
                // println!("Err: {} : {:?}", name, err);
            }
        }
    }
}
