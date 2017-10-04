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
        impl ::arraytree_lang::from::FromArrayTree for #name {
            type Parameters = ();

            fn from_array_tree_array(
                config:& ::arraytree_lang::from::FromArrayTreeConfig,
                mut array: ::arraytree_lang::tree::ArrayBranch<::arraytree_lang::tag::WithTag<::arraytree_lang::tree::ArrayTree<::arraytree_lang::leaf::StringLeaf>>>,
                tag: ::arraytree_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::arraytree_lang::error::ErrorWrite<::arraytree_lang::from::error::FromArrayTreeError>
            ) -> Result<::arraytree_lang::tag::WithTag<Self>, ()> {
                let with_tag = ::arraytree_lang::from::FromArrayTree::from_array_tree_array(
                    config,
                    array,
                    tag,
                    parameters,
                    errors,
                )?;
                Result::Ok(
                    ::arraytree_lang::tag::WithTag {
                        data: #name {
                            value: with_tag.data
                        },
                        tag: with_tag.tag,
                    }
                )
            }

            fn from_array_tree_string(
                config:& ::arraytree_lang::from::FromArrayTreeConfig,
                leaf: ::arraytree_lang::leaf::StringLeaf,
                tag: ::arraytree_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::arraytree_lang::error::ErrorWrite<::arraytree_lang::from::error::FromArrayTreeError>
            ) -> Result<::arraytree_lang::tag::WithTag<Self>, ()> {
                let with_tag = ::arraytree_lang::from::FromArrayTree::from_array_tree_string(
                    config,
                    leaf,
                    tag,
                    parameters,
                    errors,
                )?;
                Result::Ok(
                    ::arraytree_lang::tag::WithTag {
                        data: #name {
                            value: with_tag.data
                        },
                        tag: with_tag.tag,
                    }
                )
            }

            fn match_array_tree_array(
                config:& ::arraytree_lang::from::FromArrayTreeConfig,
                mut array: ::arraytree_lang::tree::ArrayBranch<::arraytree_lang::tag::WithTag<::arraytree_lang::tree::ArrayTree<::arraytree_lang::leaf::StringLeaf>>>,
                tag: ::arraytree_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::arraytree_lang::error::ErrorWrite<::arraytree_lang::from::error::FromArrayTreeError>
            ) -> bool {
                <#value_type as ::arraytree_lang::from::FromArrayTree>::match_array_tree_array(
                    config,
                    array,
                    tag,
                    parameters,
                    errors,
                )
            }

            fn match_array_tree_string(
                config:& ::arraytree_lang::from::FromArrayTreeConfig,
                leaf: ::arraytree_lang::leaf::StringLeaf,
                tag: ::arraytree_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::arraytree_lang::error::ErrorWrite<::arraytree_lang::from::error::FromArrayTreeError>
            ) -> bool {
                <#value_type as ::arraytree_lang::from::FromArrayTree>::match_array_tree_string(
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
