#![feature(io)]
#![feature(attr_literals)]
#![feature(use_extern_macros)]

extern crate arraytree_core;

#[macro_use]
extern crate arraytree_derive;

#[macro_use]
pub mod macros;

pub mod parse;
pub mod template;
pub mod tag;
pub mod tree;
pub mod from;
pub mod leaf;


pub use arraytree_core::data;
pub use arraytree_core::error;
