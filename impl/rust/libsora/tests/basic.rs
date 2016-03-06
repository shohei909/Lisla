extern crate libsora;
use libsora::sora::parse;

use std::fs;
use std::fs::File;
use std::io::Read;

const TEST_CASES_PATH: &'static str = "./../../../spec/sora/test_case/basic";

#[test]
fn main() {
    println!("{:?}", std::env::current_dir().unwrap());
    let dir = fs::read_dir(TEST_CASES_PATH).unwrap();
    let mut config = parse::Config::new();
    config.is_persevering = true;

    for result in dir {
        let entry = result.unwrap();
        let mut file = fs::File::open(entry.path()).unwrap();
        let mut string = String::new();
        file.read_to_string(&mut string).unwrap();

        let result = parse::parse(string.chars(), &config);
        match result {
            Ok(data) => {
                println!("data: {:?}", data);
            }
            Err(err) => {
                panic!("Err: {:?}", err);
            }
        }
    }
}
