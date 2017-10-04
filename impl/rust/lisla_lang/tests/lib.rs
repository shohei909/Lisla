extern crate serde;
extern crate serde_json;

#[macro_use]
extern crate arraytree_lang;

pub mod macros;
pub mod parse;

use serde_json::Value;
use arraytree_lang::tree::*;
use arraytree_lang::tag::*;
use arraytree_lang::leaf::*;

pub fn equals(arraytree: &WithTag<ArrayTree<StringLeaf>>, json: &Value, path: &str, stack: &mut Vec<usize>) {
    match (&arraytree.data, json) {
        (&ArrayTree::Array(ref s), &Value::Array(ref j)) => {
            assert!(s.vec.len() == j.len(),
                    "unmatched array length({}:{:?}): {:?} {:?}",
                    path,
                    stack,
                    s.vec.len(),
                    j.len());

            for (i, (sc, jc)) in s.vec.iter().zip(j.iter()).enumerate() {
                stack.push(i);
                equals(sc, jc, path, stack);
                stack.pop();
            }
        }

        (&ArrayTree::Leaf(ref s), &Value::String(ref j)) => {
            assert!(s.string.as_str() == j.as_str(),
                    "unmatched string({}:{:?}): {:?} {:?}",
                    path,
                    stack,
                    s,
                    j);
        }

        (_, _) => {
            panic!("unmatched({}:{:?}): {:?} {:?}", path, stack, arraytree, json);
        }
    }
}
