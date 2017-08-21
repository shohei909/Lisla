use quote::Tokens;
use syn::*;


// lisla::lisla_core::error::Errorを実装する
pub fn impl_error(ast: &DeriveInput) -> Tokens {
    let error = match ast.body {
        Body::Enum(ref _enum) =>
            impl_error_for_enum(ast, _enum),

        Body::Struct(ref _struct) =>
            impl_error_for_struct(ast, _struct),
    };

    quote! {
        #error
    }
}

// エラーの種別がstructだったときの実装
fn impl_error_for_struct(ast: &DeriveInput, variant:&VariantData) -> Tokens {
    let name = &ast.ident;
    let position = impl_position_for_struct(ast, variant);
    
    quote! {
        impl ::lisla_core::error::Error for #name {
            fn message(&self) -> String {
                // TODO:
                "message".to_string()
            }

            fn code(&self) -> ::lisla_core::error::ErrorCode {
                // TODO:
                ::lisla_core::error::ErrorCode{ value: "code".to_string() }
            }

            fn name(&self) -> String {
                "#name".to_string()
            }
        }

        #position
    }
}

// エラー位置情報の実装生成
fn impl_position_for_struct(ast: &DeriveInput, variant:&VariantData) -> Tokens {
    let name = &ast.ident;
    
    let mut range = quote!(Option::None);
    let mut source_map = quote!(Option::None);
    let mut file_path = quote!(Option::None);
    let mut project_root = quote!(Option::None);

    let fields = if let &VariantData::Struct(ref fields) = variant {
        fields
    } else {
        panic!("VariantData of {} must be struct, but actual {:?}", name, variant);
    };

    for field in fields {
        if let Option::Some(ref ident) = field.ident {
            match ident.as_ref() {
                "range" => range = get_option_value(ast, "range", &field.ty),
                "source_map" => source_map = get_option_value(ast, "source_map", &field.ty),
                "file_path" => file_path = get_option_value(ast, "file_path", &field.ty),
                "project_root" => project_root = get_option_value(ast, "project_root", &field.ty),
                _ => ()
            }
        }
    }
    
    quote! {
        impl ::data::position::Position for #name {
            fn range(&self)->Option<&::data::position::Range> {
                #range
            }
            fn source_map(&self)->Option<&::data::position::SourceMap> {
                #source_map
            }
            fn file_path(&self)->Option<&::data::position::FilePathFromProjectRoot> {
                #file_path
            }
            fn project_root(&self)->Option<&::data::position::ProjectRootPath> {
                #project_root
            }
        }
    }
}

// Option型の関数でラップしたTokensを生成
fn get_option_value(ast: &DeriveInput, field_name:&str, ty:&Ty) -> Tokens {
    if let &Ty::Path(_, ref path) = ty {
        if path.segments.len() == 1 {
            let field_ident = Ident::new(field_name.to_string());
            if path.segments[0].ident.as_ref() == "Option" {
                quote!{ self.#field_ident.as_ref() }
            } else {
                quote!{ Option::Some(&self.#field_ident) }
            }
        } else {
            panic!("type path length of `{}`.`{}` must be 1, but actual `{}`", ast.ident, field_name, path.segments.len());
        }
    } else {
        panic!("type of `{}`.`{}` must be Path, but actual `{:?}`", ast.ident, field_name, ty);
    }
}

// エラーのアイテムがenumだったときの実装
fn impl_error_for_enum(ast: &DeriveInput, variants:&Vec<Variant>) -> Tokens {
    let name = &ast.ident;
    let mut arms:Tokens = Tokens::new();

    for variant in variants {
        let variant_name = &variant.ident;
        arms.append(
            quote!(&#name::#variant_name(ref error) => { error })
        )
    }

    let from_impl = impl_error_from_for_enum(ast, variants);

    quote! {
        // このエラー情報をそのまま伝搬する
        impl ::lisla_core::error::Error for #name {
            fn message(&self) -> String {
                ::lisla_core::error::ErrorHolder::child_error(self).message()
            }

            fn code(&self) -> ::lisla_core::error::ErrorCode {
                ::lisla_core::error::ErrorHolder::child_error(self).code()
            }

            fn name(&self) -> String {
                ::lisla_core::error::ErrorHolder::child_error(self).name()
            }
        }

        // 子のエラーの位置情報をそのまま伝搬する
        impl ::data::position::Position for #name {
            fn range(&self)->Option<&Range> {
                ::lisla_core::error::ErrorHolder::child_error(self).range()
            }
            fn source_map(&self)->Option<&SourceMap> {
                ::lisla_core::error::ErrorHolder::child_error(self).source_map()
            }
            fn file_path(&self)->Option<&FilePathFromProjectRoot> {
                ::lisla_core::error::ErrorHolder::child_error(self).file_path()
            }
            fn project_root(&self)->Option<&ProjectRootPath> {
                ::lisla_core::error::ErrorHolder::child_error(self).project_root()
            }
        }

        // enumのErrorは、さらに子となるエラーを持つ
        impl ::lisla_core::error::ErrorHolder for #name {
            fn child_error(&self) -> &::lisla_core::error::Error {
                match self {
                    #arms
                }
            }
        }

        #from_impl
    }
}


// エラーのアイテムがenumだったときのFromトレイト実装
fn impl_error_from_for_enum(ast: &DeriveInput, variants:&Vec<Variant>) -> Tokens {
    let name = &ast.ident;
    let mut from_impl:Tokens = Tokens::new();

    for variant in variants {
        let variant_name = &variant.ident;
        if let &VariantData::Tuple(ref vec) = &variant.data {
            let len = vec.len();
            if len == 1 {
                let variant_type = &vec[0];
                from_impl.append(
                    quote!(
                        impl ::std::convert::From<#variant_type> for #name {
                            fn from(error: #variant_type) -> Self {
                                #name::#variant_name(error)
                            }
                        }
                    )
                )
            } else {
                panic!("VariantData of {} arguments length must be 1, but actual {:?}", name, len);
            };
        } else {
            panic!("VariantData of {} must be tuple, but actual {:?}", name, variant);
        };
    }

    from_impl
}
