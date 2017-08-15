#![feature(io)]
#![feature(attr_literals)]
#![feature(use_extern_macros)]
//#![feature(macro_rules)]

extern crate linked_hash_map;

#[macro_use]
extern crate lisla_derive;

#[macro_use]
pub mod macros;

pub mod data;
pub mod parse;
pub mod template;
pub mod script;
pub mod error;

