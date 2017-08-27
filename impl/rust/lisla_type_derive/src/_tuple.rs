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
                            MetaItem::List(ref ident, ref items) if (ident == "lisla") => {
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
                                #ident : ::lisla_lang::from::FromArrayTree::from_array_tree(
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
                                    ::lisla_lang::from::FromArrayTree::from_array_tree_array(
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
        impl ::lisla_lang::from::FromArrayTree for #name {
            type Parameters = ();
            fn from_array_tree_array(
                config:& ::lisla_lang::from::FromArrayTreeConfig,
                mut array: ::lisla_lang::tree::ArrayBranch<::lisla_lang::tag::WithTag<::lisla_lang::tree::ArrayTree<::lisla_lang::leaf::StringLeaf>>>,
                tag: ::lisla_lang::tag::Tag,
                parameters: Self::Parameters,
                errors:&mut ErrorWrite<FromArrayTreeError>
            ) -> Result<::lisla_lang::tag::WithTag<Self>, ()> {
                let data = #name {
                    #parameters
                };
                array.finish(config, &tag, errors)?;
                Result::Ok(
                    ::lisla_lang::tag::WithTag {
                        data,
                        tag,
                    }  
                )
            }
        }
    }
}

enum ShiftKind {
    Shift,
    Spreads(Option<Lit>),
}
