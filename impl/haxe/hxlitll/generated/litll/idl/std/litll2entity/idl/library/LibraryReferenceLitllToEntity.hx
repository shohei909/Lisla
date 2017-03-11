// This file is generated by hxlitll.
package litll.idl.std.litll2entity.idl.library;
class LibraryReferenceLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.entity.idl.library.LibraryReference, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (context.litll) {
            case litll.core.Litll.Str(_):{
                hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString));
            };
            case litll.core.Litll.Arr(array):{
                var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
                var instance = {
                    var arg0 = switch (arrayContext.read(litll.idl.std.litll2entity.idl.LibraryNameLitllToEntity.process)) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Err(data):{
                            return hxext.ds.Result.Err(data);
                        };
                    };
                    var arg1 = switch (arrayContext.read(litll.idl.std.litll2entity.idl.library.LibraryVersionLitllToEntity.process)) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Err(data):{
                            return hxext.ds.Result.Err(data);
                        };
                    };
                    var instance = new litll.idl.std.entity.idl.library.LibraryReference(arg0, arg1);
                    hxext.ds.Result.Ok(instance);
                };
                switch (arrayContext.closeOrError()) {
                    case haxe.ds.Option.None:{
                        instance;
                    };
                    case haxe.ds.Option.Some(data):{
                        hxext.ds.Result.Err(data);
                    };
                };
            };
        };
    }
    public static function variableInlineProcess(arrayContext:litll.idl.litll2entity.LitllToEntityArrayContext):hxext.ds.Result<litll.idl.std.entity.idl.library.LibraryReference, litll.idl.litll2entity.error.LitllToEntityError> return null;
}