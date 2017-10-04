#![feature(attr_literals)]
#![feature(use_extern_macros)]
#![feature(custom_attribute)]

#[macro_use]
extern crate arraytree_derive;

#[macro_use]
extern crate arraytree_type_derive;

#[macro_use]
extern crate arraytree_lang;
extern crate arraytree_core;

pub mod error;
pub mod types;
