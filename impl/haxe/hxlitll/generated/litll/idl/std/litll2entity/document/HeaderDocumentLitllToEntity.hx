// This file is generated by hxlitll.
package litll.idl.std.litll2entity.document;
class HeaderDocumentLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.entity.document.HeaderDocument, litll.idl.litll2entity.error.LitllToEntityError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                var arg1 = [];
                var arg2 = [];
                var arg3 = haxe.ds.Option.None;
                var arg4 = haxe.ds.Option.None;
                var arg5 = haxe.ds.Option.None;
                for (litllData in array.data) {
                    var context = new litll.idl.litll2entity.LitllToEntityContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "encoding")) && array.data[1].match(litll.core.Litll.Str(_.data => "utf8"))):switch (arg0) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementDuplicated("encoding")));
                            };
                            case haxe.ds.Option.None:{
                                arg0 = haxe.ds.Option.Some({
                                    var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                                    switch (litll.idl.std.litll2entity.document.DocumentEncodingLitllToEntity.process(context)) {
                                        case hxext.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case hxext.ds.Result.Err(data):{
                                            return hxext.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "license")) && array.data[1].match(litll.core.Litll.Str(_))):arg1.push({
                            var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                            switch (litll.idl.std.litll2entity.document.LicenseLitllToEntity.process(context)) {
                                case hxext.ds.Result.Ok(data):{
                                    data;
                                };
                                case hxext.ds.Result.Err(data):{
                                    return hxext.ds.Result.Err(data);
                                };
                            };
                        });
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "author")) && array.data[1].match(litll.core.Litll.Str(_))):arg2.push({
                            var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                            switch (litll.idl.std.litll2entity.document.AuthorLitllToEntity.process(context)) {
                                case hxext.ds.Result.Ok(data):{
                                    data;
                                };
                                case hxext.ds.Result.Err(data):{
                                    return hxext.ds.Result.Err(data);
                                };
                            };
                        });
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "type"))):switch (arg3) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementDuplicated("type")));
                            };
                            case haxe.ds.Option.None:{
                                arg3 = haxe.ds.Option.Some({
                                    var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                                    switch (litll.idl.std.litll2entity.idl.TypeReferenceLitllToEntity.process(context)) {
                                        case hxext.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case hxext.ds.Result.Err(data):{
                                            return hxext.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "type_note")) && array.data[1].match(litll.core.Litll.Arr(_))):switch (arg4) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementDuplicated("type_note")));
                            };
                            case haxe.ds.Option.None:{
                                arg4 = haxe.ds.Option.Some({
                                    var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                                    switch (litll.idl.std.litll2entity.idl.portable.PortableIdlLitllToEntity.process(context)) {
                                        case hxext.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case hxext.ds.Result.Err(data):{
                                            return hxext.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "document_markup")) && array.data[1].match(litll.core.Litll.Str(_))):switch (arg5) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementDuplicated("document_markup")));
                            };
                            case haxe.ds.Option.None:{
                                arg5 = haxe.ds.Option.Some({
                                    var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                                    switch (litll.idl.std.litll2entity.document.DocumentMarkupLanguageLitllToEntity.process(context)) {
                                        case hxext.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case hxext.ds.Result.Err(data):{
                                            return hxext.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case litllData:return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedStructElement(["encoding", "license", "author", "type", "type_note", "document_markup"])));
                    };
                };
                var instance = new litll.idl.std.entity.document.HeaderDocument(arg0, arg1, arg2, arg3, arg4, arg5);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
}