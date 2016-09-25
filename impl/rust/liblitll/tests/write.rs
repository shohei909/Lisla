extern crate liblitll;
extern crate rustc_serialize;

use liblitll::litll::*;
use liblitll::litll::tag::QuoteKind;

use std::fs;
use std::io::Read;
use std::collections::HashMap;

const TEST_CASES_PATH: &'static str = "./../../../spec/litll/test_case/";

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

        let litll_string = into_iter.next().unwrap().str().unwrap();
        let litll_data = parse::parse(litll_string.chars(), &parse_config).unwrap();

        for (name, write_config) in write_configs.iter() {
            let rewrited_string = write::write(write_config, &litll_data);
            println!("{}: {}", name, rewrited_string);

            let reparsed_litll_data = parse::parse(rewrited_string.chars(), &parse_config).unwrap();

            equals(&litll_data,
                   &reparsed_litll_data,
                   "json_compatible" != *name,
                   entry.path().to_str().unwrap(),
                   &mut vec![]);
        }
    }
}

fn equals(litll0: &LitllArray,
          litll1: &LitllArray,
          keeping_quote: bool,
          path: &str,
          stack: &mut Vec<usize>) {
    assert!(litll0.data.len() == litll1.data.len(),
            "unmatched array length({}:{:?}): {:?} {:?}",
            path,
            stack,
            litll0.data.len(),
            litll1.data.len());

    for (i, tuple) in litll0.data.iter().zip(litll1.data.iter()).enumerate() {
        stack.push(i);
        match tuple {
            (&Litll::Array(ref s0), &Litll::Array(ref s1)) => {
                equals(s0, s1, keeping_quote, path, stack);
            }

            (&Litll::String(ref s0), &Litll::String(ref s1)) => {
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
