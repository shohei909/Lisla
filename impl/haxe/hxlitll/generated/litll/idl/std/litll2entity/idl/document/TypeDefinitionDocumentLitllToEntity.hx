// This file is generated by hxlitll.
package litll.idl.std.litll2entity.idl.document;
class TypeDefinitionDocumentLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.idl.document.TypeDefinitionDocument, litll.idl.litll2entity.error.LitllToEntityError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = [];
                var arg1 = haxe.ds.Option.None;
                var arg2 = [];
                var arg3 = [];
                var arg4 = [];
                for (litllData in array.data) {
                    var context = new litll.idl.litll2entity.LitllToEntityContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "document_tag"))):arg0.push({
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
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "completion_const"))):arg2.push({
                            var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                            switch (litll.idl.std.litll2entity.core.AnyLitllToEntity.process(context)) {
                                case hxext.ds.Result.Ok(data):{
                                    data;
                                };
                                case hxext.ds.Result.Err(data):{
                                    return hxext.ds.Result.Err(data);
                                };
                            };
                        });
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "completion_type"))):arg3.push({
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
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "highlight")) && array.data[1].match(litll.core.Litll.Str(_))):arg4.push({
                            var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                            switch (litll.idl.std.litll2entity.util.highlight.HighlightScopeLitllToEntity.process(context)) {
                                case hxext.ds.Result.Ok(data):{
                                    data;
                                };
                                case hxext.ds.Result.Err(data):{
                                    return hxext.ds.Result.Err(data);
                                };
                            };
                        });
                        case litllData:return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedStructElement([])));
                    };
                };
                var instance = new litll.idl.std.data.idl.document.TypeDefinitionDocument(arg0, arg1, arg2, arg3, arg4);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
    public static function fixedInlineProcess(context:litll.idl.litll2entity.LitllToEntityArrayContext):hxext.ds.Result<litll.idl.std.data.idl.document.TypeDefinitionDocument, litll.idl.litll2entity.error.LitllToEntityError> return null;
}