#![feature(attr_literals)]
#![recursion_limit="256"]

extern crate proc_macro;
extern crate syn;

#[macro_use]
extern crate quote;

use proc_macro::TokenStream;

mod structure;
mod newtype;
mod _tuple;
mod union;

use structure::impl_structure;
use newtype::impl_newtype;
use _tuple::impl_tuple;
use union::impl_union;

#[proc_macro_derive(LislaStruct, attributes(lisla))]
pub fn derive_structure(input: TokenStream) -> TokenStream {
    let s = input.to_string();
    let ast = syn::parse_derive_input(&s).unwrap();
    let implemention = impl_structure(&ast);
    
    implemention.parse().unwrap()
}

#[proc_macro_derive(LislaNewtype, attributes(lisla))]
pub fn derive_newtype(input: TokenStream) -> TokenStream {
    let s = input.to_string();
    let ast = syn::parse_derive_input(&s).unwrap();
    let implemention = impl_newtype(&ast);
    
    implemention.parse().unwrap()
}

#[proc_macro_derive(LislaTuple, attributes(lisla))]
pub fn derive_tuple(input: TokenStream) -> TokenStream {
    let s = input.to_string();
    let ast = syn::parse_derive_input(&s).unwrap();
    let implemention = impl_tuple(&ast);
    
    implemention.parse().unwrap()
}

#[proc_macro_derive(LislaUnion, attributes(lisla))]
pub fn derive_union(input: TokenStream) -> TokenStream {
    let s = input.to_string();
    let ast = syn::parse_derive_input(&s).unwrap();
    let implemention = impl_union(&ast);

    implemention.parse().unwrap()
}
