use quote::Tokens;
use syn::*;

pub fn impl_newtype(ast: &DeriveInput) -> Tokens {
    let name = &ast.ident;
    let option_value_type = Option::None;

    if let Body::Struct(VariantData::Struct(fields)) = ast.body {
        for field in fields {
            if let Option::Some("value") = field.ident {
                option_value_type
            }
        }
    } else {
       panic!("#[derive(LislaNewtype)] is only defined for struct, not for enum or tuple.");
    }

    let value_type = if Option::Some(value_type) = option_value_type {
        value_type
    } else {
        panic!("parameter 'value' is required");
    };

    quote! {
        impl ::lisla_lang::from::FromArrayTree for #name {
            type Parameters = ();

            fn from_array_tree_array(
                config:& ::lisla_lang::from::FromArrayTreeConfig,
                mut array: ::lisla_lang::tree::ArrayBranch<::lisla_lang::tag::WithTag<::lisla_lang::tree::ArrayTree<::lisla_lang::leaf::StringLeaf>>>,
                tag: ::lisla_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::lisla_lang::error::ErrorWrite<::lisla_lang::from::error::FromArrayTreeError>
            ) -> Result<::lisla_lang::tag::WithTag<Self>, ()> {
                let with_tag = ::lisla_lang::from::FromArrayTree::from_array_tree_array(
                    config,
                    array,
                    tag,
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

            fn from_array_tree_string(
                config:& ::lisla_lang::from::FromArrayTreeConfig,
                leaf: ::lisla_lang::leaf::StringLeaf,
                tag: ::lisla_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::lisla_lang::error::ErrorWrite<::lisla_lang::from::error::FromArrayTreeError>
            ) -> Result<::lisla_lang::tag::WithTag<Self>, ()> {
                let with_tag = ::lisla_lang::from::FromArrayTree::from_array_tree_string(
                    config,
                    leaf,
                    tag,
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
                mut array: ::lisla_lang::tree::ArrayBranch<::lisla_lang::tag::WithTag<::lisla_lang::tree::ArrayTree<::lisla_lang::leaf::StringLeaf>>>,
                tag: ::lisla_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::lisla_lang::error::ErrorWrite<::lisla_lang::from::error::FromArrayTreeError>
            ) -> bool {
                <#value_type as ::lisla_lang::from::FromArrayTree>::match_array_tree_array(
                    config,
                    array,
                    tag,
                    parameters,
                    errors,
                )
            }

            fn match_array_tree_string(
                config:& ::lisla_lang::from::FromArrayTreeConfig,
                leaf: ::lisla_lang::leaf::StringLeaf,
                tag: ::lisla_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::lisla_lang::error::ErrorWrite<::lisla_lang::from::error::FromArrayTreeError>
            ) -> bool {
                <#value_type as ::lisla_lang::from::FromArrayTree>::match_array_tree_string(
                    config,
                    leaf,
                    tag,
                    parameters,
                    errors,
                )
            }
        }
    }
}
