#![feature(attr_literals)]
#![feature(use_extern_macros)]
#![feature(custom_attribute)]

#[macro_use]
extern crate lisla_derive;

#[macro_use]
extern crate lisla_type_derive;

#[macro_use]
extern crate lisla_lang;
extern crate lisla_core;

pub mod error;
pub mod types;
