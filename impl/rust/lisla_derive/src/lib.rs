#![feature(attr_literals)]
#![recursion_limit="128"]

extern crate proc_macro;
extern crate syn;
#[macro_use]
extern crate quote;

mod error;

use proc_macro::TokenStream;
use error::impl_error;

#[proc_macro_derive(Error, attributes(message, code))]
pub fn derive_error(input: TokenStream) -> TokenStream {
    let s = input.to_string();
    let ast = syn::parse_derive_input(&s).unwrap();
    let implemention = impl_error(&ast);
    
    implemention.parse().unwrap()
}
