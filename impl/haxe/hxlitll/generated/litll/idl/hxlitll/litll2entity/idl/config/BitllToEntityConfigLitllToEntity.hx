// This file is generated by hxlitll.
package litll.idl.hxlitll.litll2entity.idl.config;
import litll.idl.litll2entity.error.LitllToEntityError;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;
class BitllToEntityConfigLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.hxlitll.data.idl.config.BitllToEntityConfig, litll.idl.litll2entity.error.LitllToEntityError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                for (litllData in array.data) {
                    var context = new litll.idl.litll2entity.LitllToEntityContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "filter")) && array.data[1].match(litll.core.Litll.Arr(_))):switch (arg0) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementDuplicated("filter")));
                            };
                            case haxe.ds.Option.None:{
                                arg0 = haxe.ds.Option.Some({
                                    var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                                    switch (litll.idl.hxlitll.litll2entity.idl.config.FilterDeclarationLitllToEntity.process(context)) {
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
                        case litllData:return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedStructElement([])));
                    };
                };
                var instance = new litll.idl.hxlitll.data.idl.config.BitllToEntityConfig(switch (arg0) {
                    case haxe.ds.Option.Some(data):{
                        data;
                    };
                    case haxe.ds.Option.None:{
                        return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementNotFound("filter")));
                    };
                });
                hxext.ds.Result.Ok(instance);
            };
        };
    };
}