use quote::Tokens;
use syn::*;

pub fn impl_newtype(ast: &DeriveInput) -> Tokens {
    let name = &ast.ident;
    quote! {
        impl ::lisla_lang::from::FromArrayTree for #name {
            type Parameters = ();

            fn from_array_tree_array(
                config:& ::lisla_lang::from::FromArrayTreeConfig,
                tree: ::lisla_lang::tag::WithTag<::lisla_lang::tree::ArrayTree<::lisla_lang::leaf::StringLeaf>>,
                parameters: Self::Parameters,
                errors:&mut ::lisla_lang::error::ErrorWrite<::lisla_lang::from::error::FromArrayTreeError>
            ) -> Result<::lisla_lang::tag::WithTag<Self>, ()> {
                let with_tag = ::lisla_lang::from::FromArrayTree::from_array_tree_array(
                    config,
                    tree,
                    parameters,
                    errors,
                )?;
                Result::Ok(
                    ::lisla_lang::tag::WithTag {
                        data: #name {
                            value: with_tag.data
                        },
                        tag: with_tag.tag,
                    }
                )
            }

            fn match_array_tree_array(
                config:& ::lisla_lang::from::FromArrayTreeConfig,
                tree: ::lisla_lang::tag::WithTag<::lisla_lang::tree::ArrayTree<::lisla_lang::leaf::StringLeaf>>,
                parameters: Self::Parameters,
                errors:&mut ::lisla_lang::error::ErrorWrite<::lisla_lang::from::error::FromArrayTreeError>
            ) -> Result<::lisla_lang::tag::WithTag<Self>, ()> {
                ::lisla_lang::from::FromArrayTree::match_array_tree_array(
                    config,
                    tree,
                    parameters,
                    errors,
                )
            }
        }
    }
}
