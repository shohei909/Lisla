use quote::Tokens;
use syn::*;

pub fn impl_tuple(ast: &DeriveInput) -> Tokens {
    let name = &ast.ident;
    let mut parameters = Tokens::new();

    if let &Body::Struct(VariantData::Struct(ref fields)) = &ast.body {
        for field in fields {
            if let Option::Some(ref ident) = field.ident {
                let mut children = Tokens::new();
                let mut get_kind = ShiftKind::Shift;
                for attr in &field.attrs {
                    if AttrStyle::Outer == attr.style {
                        match attr.value {
                            MetaItem::List(ref ident, ref items) if (ident == "arraytree") => {
                                for item in items {
                                    match item {
                                        &NestedMetaItem::MetaItem(MetaItem::NameValue(ref ident, ref value)) if (ident == "label") => {
                                            children.append(
                                                quote!{ array_tree!(#value).data }
                                            );
                                        }
                                        &NestedMetaItem::MetaItem(MetaItem::Word(ref ident)) if (ident == "spreads_rest") => {
                                            get_kind = ShiftKind::Spreads(Option::None);
                                        }
                                        &NestedMetaItem::MetaItem(MetaItem::NameValue(ref ident, ref lit)) if (ident == "spreads") => {
                                            get_kind = ShiftKind::Spreads(Option::Some(lit.clone()));
                                        }
                                        _ => {}
                                    }
                                }
                            }
                            _ => {}
                        } 
                    }
                }
                
                match get_kind {
                    ShiftKind::Shift => {
                        parameters.append(
                            quote! {
                                #ident : ::arraytree_lang::from::FromArrayTree::from_array_tree(
                                    config,
                                    array.shift(config, &tag, errors)?,
                                    (#children),
                                    errors
                                )?,
                            }
                        )
                    }
                    ShiftKind::Spreads(lit) => {
                        let token = if let Option::Some(_lit) = lit {
                            quote!{ array.split_off(config, #_lit, &tag, errors)? }
                        } else {
                            quote!{ array.split_off_rest(config, &tag, errors)? }
                        };
                        parameters.append(
                            quote! {
                                #ident : {
                                    let data = #token;
                                    ::arraytree_lang::from::FromArrayTree::from_array_tree_array(
                                        config,
                                        data,
                                        tag.clone(),
                                        (#children),
                                        errors
                                    )?
                                }
                            }
                        )
                    }
                }
            }
        }
    } else {
       panic!("#[derive(LislaTuple)] is only defined for struct, not for enum or tuple.");
    }
    quote! {
        #[allow(unused_variables)]
        impl ::arraytree_lang::from::FromArrayTree for #name {
            type Parameters = ();
            fn from_array_tree_array(
                config:& ::arraytree_lang::from::FromArrayTreeConfig,
                mut array: ::arraytree_lang::tree::ArrayBranch<::arraytree_lang::tag::WithTag<::arraytree_lang::tree::ArrayTree<::arraytree_lang::leaf::StringLeaf>>>,
                tag: ::arraytree_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ErrorWrite<FromArrayTreeError>
            ) -> Result<::arraytree_lang::tag::WithTag<Self>, ()> {
                let data = #name {
                    #parameters
                };
                array.finish(config, &tag, errors)?;
                Result::Ok(
                    ::arraytree_lang::tag::WithTag {
                        data,
                        tag,
                    }  
                )
            }

            #[allow(unused_variables)]
            fn from_array_tree_string(
                config:& ::arraytree_lang::from::FromArrayTreeConfig,
                leaf: ::arraytree_lang::leaf::StringLeaf,
                tag: ::arraytree_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::arraytree_lang::error::ErrorWrite<::arraytree_lang::from::error::FromArrayTreeError>
            ) -> Result<WithTag<Self>, ()> {
                errors.push(
                    FromArrayTreeError::from(
                        CantBeStringError {
                            range: tag.content_range
                        }
                    )
                );
                Result::Err(())
            }

            fn match_array_tree_array(
                config:& ::arraytree_lang::from::FromArrayTreeConfig,
                mut array: ::arraytree_lang::tree::ArrayBranch<::arraytree_lang::tag::WithTag<::arraytree_lang::tree::ArrayTree<::arraytree_lang::leaf::StringLeaf>>>,
                tag: ::arraytree_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::arraytree_lang::error::ErrorWrite<::arraytree_lang::from::error::FromArrayTreeError>
            ) -> bool {
                true
            }

            fn match_array_tree_string(
                config:& ::arraytree_lang::from::FromArrayTreeConfig,
                leaf: ::arraytree_lang::leaf::StringLeaf,
                tag: ::arraytree_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ::arraytree_lang::error::ErrorWrite<::arraytree_lang::from::error::FromArrayTreeError>
            ) -> bool {
                false
            }
        }
    }
}

enum ShiftKind {
    Shift,
    Spreads(Option<Lit>),
}
