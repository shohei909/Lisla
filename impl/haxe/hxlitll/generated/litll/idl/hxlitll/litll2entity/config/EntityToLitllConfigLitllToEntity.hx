// This file is generated by hxlitll.
package litll.idl.hxlitll.litll2entity.config;
class EntityToLitllConfigLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.hxlitll.data.config.EntityToLitllConfig, litll.idl.litll2entity.error.LitllToEntityError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = [];
                for (litllData in array.data) {
                    var context = new litll.idl.litll2entity.LitllToEntityContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "filter"))):arg0.push(switch (litll.idl.hxlitll.litll2entity.config.FilterDeclarationLitllToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Err(data):{
                                return hxext.ds.Result.Err(data);
                            };
                        });
                        case litllData:return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedStructElement(["filter"])));
                    };
                };
                var instance = new litll.idl.hxlitll.data.config.EntityToLitllConfig(arg0);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
    public static function variableInlineProcess(arrayContext:litll.idl.litll2entity.LitllToEntityArrayContext):hxext.ds.Result<litll.idl.hxlitll.data.config.EntityToLitllConfig, litll.idl.litll2entity.error.LitllToEntityError> return null;
}