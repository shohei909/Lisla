// This file is generated by hxlitll.
package litll.idl.std.litll2backend.idl.document;
class TypeReferenceDocumentLitllToBackend {
    public static function process(context:litll.idl.litll2backend.LitllToBackendContext):litll.core.ds.Result<litll.idl.std.data.idl.document.TypeReferenceDocument, litll.idl.litll2backend.LitllToBackendError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Err(litll.idl.litll2backend.LitllToBackendError.ofLitll(context.litll, litll.idl.litll2backend.LitllToBackendErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                var arg1 = [];
                var arg2 = [];
                for (litllData in array.data) {
                    var context = new litll.idl.litll2backend.LitllToBackendContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "completion_const"))):arg1.push({
                            var context = new litll.idl.litll2backend.LitllToBackendContext(array.data[1], context.config);
                            switch (litll.idl.std.litll2backend.core.AnyLitllToBackend.process(context)) {
                                case litll.core.ds.Result.Ok(data):{
                                    data;
                                };
                                case litll.core.ds.Result.Err(data):{
                                    return litll.core.ds.Result.Err(data);
                                };
                            };
                        });
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "completion_type"))):arg2.push({
                            var context = new litll.idl.litll2backend.LitllToBackendContext(array.data[1], context.config);
                            switch (litll.idl.std.litll2backend.idl.TypeReferenceLitllToBackend.process(context)) {
                                case litll.core.ds.Result.Ok(data):{
                                    data;
                                };
                                case litll.core.ds.Result.Err(data):{
                                    return litll.core.ds.Result.Err(data);
                                };
                            };
                        });
                        case litllData:return litll.core.ds.Result.Err(litll.idl.litll2backend.LitllToBackendError.ofLitll(litllData, litll.idl.litll2backend.LitllToBackendErrorKind.UnmatchedStructElement([])));
                    };
                };
                var instance = new litll.idl.std.data.idl.document.TypeReferenceDocument(arg0, arg1, arg2);
                litll.core.ds.Result.Ok(instance);
            };
        };
    };
}