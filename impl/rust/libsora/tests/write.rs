extern crate libsora;
extern crate rustc_serialize;

use libsora::sora::*;
use libsora::sora::tag::QuoteKind;

use std::fs;
use std::io::Read;
use std::collections::HashMap;

const TEST_CASES_PATH: &'static str = "./../../../spec/sora/test_case/";

#[test]
fn test_basic() {
    let path = format!("{}{}", TEST_CASES_PATH, "basic");
    let dir = fs::read_dir(path).unwrap();
    let mut parse_config = parse::Config::new();
    parse_config.is_persevering = true;

    let mut write_configs = HashMap::new();
    write_configs.insert("minified", write::Config::minified());
    write_configs.insert("pretty", write::Config::pretty());
    write_configs.insert("json_compatible", write::Config::json_compatible(true));

    for result in dir {
        let entry = result.unwrap();
        let metadata = entry.metadata().unwrap();
        if metadata.is_dir() {
            continue;
        }

        let mut file = fs::File::open(entry.path()).unwrap();
        let mut string = String::new();
        file.read_to_string(&mut string).unwrap();

        let case_data = parse::parse(string.chars(), &parse_config).unwrap();
        let mut into_iter = case_data.data.into_iter();

        let sora_string = into_iter.next().unwrap().str().unwrap();
        let sora_data = parse::parse(sora_string.chars(), &parse_config).unwrap();

        for (name, write_config) in write_configs.iter() {
            let rewrited_string = write::write(write_config, &sora_data);
            println!("{}: {}", name, rewrited_string);

            let reparsed_sora_data = parse::parse(rewrited_string.chars(), &parse_config).unwrap();

            equals(&sora_data,
                   &reparsed_sora_data,
                   "json_compatible" != *name,
                   entry.path().to_str().unwrap(),
                   &mut vec![]);
        }
    }
}

fn equals(sora0: &SoraArray,
          sora1: &SoraArray,
          keeping_quote: bool,
          path: &str,
          stack: &mut Vec<usize>) {
    assert!(sora0.data.len() == sora1.data.len(),
            "unmatched array length({}:{:?}): {:?} {:?}",
            path,
            stack,
            sora0.data.len(),
            sora1.data.len());

    for (i, tuple) in sora0.data.iter().zip(sora1.data.iter()).enumerate() {
        stack.push(i);
        match tuple {
            (&Sora::Array(ref s0), &Sora::Array(ref s1)) => {
                equals(s0, s1, keeping_quote, path, stack);
            }

            (&Sora::String(ref s0), &Sora::String(ref s1)) => {
                assert!(s0.data.as_str() == s1.data.as_str(),
                        "unmatched string({}:{:?}): {:?} {:?}",
                        path,
                        stack,
                        s0.data,
                        s1.data);

                if keeping_quote {
                    assert!((s0.tag.detail.quote == QuoteKind::Unquoted) ==
                            (s1.tag.detail.quote == QuoteKind::Unquoted),
                            "unmatched quote({}:{:?}): {:?} {:?}",
                            path,
                            stack,
                            s0.tag.detail.quote,
                            s1.tag.detail.quote);
                }
            }

            (_, _) => {
                panic!("unmatched({}:{:?}): {:?}", path, stack, tuple);
            }
        }

        stack.pop();
    }
}
