// This file is generated by hxlitll.
package litll.idl.hxlitll.litll2entity.config;
class FilterDeclarationLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.hxlitll.data.config.FilterDeclaration, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (context.litll) {
            case litll.core.Litll.Str(_):{
                hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString));
            };
            case litll.core.Litll.Arr(data):{
                var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(data, 0, context.config);
                var instance = {
                    arrayContext.readLabel("filter");
                    var arg0 = switch (arrayContext.readFixedInline(litll.idl.std.litll2entity.idl.group.TypeGroupFilterLitllToEntity.fixedInlineProcess, 2)) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Err(data):{
                            return hxext.ds.Result.Err(data);
                        };
                    };
                    var instance = new litll.idl.hxlitll.data.config.FilterDeclaration(arg0);
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
    public static function fixedInlineProcess(context:litll.idl.litll2entity.LitllToEntityArrayContext):hxext.ds.Result<litll.idl.hxlitll.data.config.FilterDeclaration, litll.idl.litll2entity.error.LitllToEntityError> return null;
    public static function variableInlineProcess(context:litll.idl.litll2entity.LitllToEntityArrayContext):hxext.ds.Result<litll.idl.hxlitll.data.config.FilterDeclaration, litll.idl.litll2entity.error.LitllToEntityError> return null;
}