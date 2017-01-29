// This file is generated by hxlitll.
package litll.idl.std.delitllfy.document;
class HeaderDocumentDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.document.HeaderDocument, litll.idl.delitllfy.DelitllfyError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.CantBeString));
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
                    var context = new litll.idl.delitllfy.DelitllfyContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "encoding")) && array.data[1].match(litll.core.Litll.Str(_.data => "utf8"))):switch (arg0) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litll, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDupplicated("encoding")));
                            };
                            case haxe.ds.Option.None:{
                                arg0 = haxe.ds.Option.Some({
                                    var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                                    switch (litll.idl.std.delitllfy.document.DocumentEncodingDelitllfier.process(context)) {
                                        case litll.core.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case litll.core.ds.Result.Err(data):{
                                            return litll.core.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "license")) && array.data[1].match(litll.core.Litll.Str(_))):arg1.push({
                            var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                            switch (litll.idl.std.delitllfy.document.LicenseDelitllfier.process(context)) {
                                case litll.core.ds.Result.Ok(data):{
                                    data;
                                };
                                case litll.core.ds.Result.Err(data):{
                                    return litll.core.ds.Result.Err(data);
                                };
                            };
                        });
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "author")) && array.data[1].match(litll.core.Litll.Str(_))):arg2.push({
                            var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                            switch (litll.idl.std.delitllfy.document.AuthorDelitllfier.process(context)) {
                                case litll.core.ds.Result.Ok(data):{
                                    data;
                                };
                                case litll.core.ds.Result.Err(data):{
                                    return litll.core.ds.Result.Err(data);
                                };
                            };
                        });
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "schema"))):switch (arg3) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litll, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDupplicated("schema")));
                            };
                            case haxe.ds.Option.None:{
                                arg3 = haxe.ds.Option.Some({
                                    var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                                    switch (litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier.process(context)) {
                                        case litll.core.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case litll.core.ds.Result.Err(data):{
                                            return litll.core.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "schema_note")) && array.data[1].match(litll.core.Litll.Arr(_))):switch (arg4) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litll, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDupplicated("schema_note")));
                            };
                            case haxe.ds.Option.None:{
                                arg4 = haxe.ds.Option.Some({
                                    var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                                    switch (litll.idl.std.delitllfy.idl.portable.PortableIdlDelitllfier.process(context)) {
                                        case litll.core.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case litll.core.ds.Result.Err(data):{
                                            return litll.core.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "document_markup")) && array.data[1].match(litll.core.Litll.Str(_))):switch (arg5) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litll, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDupplicated("document_markup")));
                            };
                            case haxe.ds.Option.None:{
                                arg5 = haxe.ds.Option.Some({
                                    var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                                    switch (litll.idl.std.delitllfy.document.DocumentMarkupLanguageDelitllfier.process(context)) {
                                        case litll.core.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case litll.core.ds.Result.Err(data):{
                                            return litll.core.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case litllData:return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litllData, litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedStructElement([])));
                    };
                };
                var instance = new litll.idl.std.data.document.HeaderDocument(arg0, arg1, arg2, arg3, arg4, arg5);
                litll.core.ds.Result.Ok(instance);
            };
        };
    };
}