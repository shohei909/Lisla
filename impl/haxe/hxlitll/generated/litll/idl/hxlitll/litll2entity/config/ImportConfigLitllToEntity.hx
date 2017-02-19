// This file is generated by hxlitll.
package litll.idl.hxlitll.litll2entity.config;
class ImportConfigLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.hxlitll.data.config.ImportConfig, litll.idl.litll2entity.error.LitllToEntityError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                for (litllData in array.data) {
                    var context = new litll.idl.litll2entity.LitllToEntityContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "haxe_source")) && array.data[1].match(litll.core.Litll.Str(_))):switch (arg0) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementDuplicated("haxe_source")));
                            };
                            case haxe.ds.Option.None:{
                                arg0 = haxe.ds.Option.Some({
                                    var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                                    switch (litll.idl.std.litll2entity.util.file.DirectoryPathLitllToEntity.process(context)) {
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
                        case litllData:return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedStructElement(["haxe_source"])));
                    };
                };
                var instance = new litll.idl.hxlitll.data.config.ImportConfig(switch (arg0) {
                    case haxe.ds.Option.Some(data):{
                        data;
                    };
                    case haxe.ds.Option.None:{
                        return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementNotFound("haxe_source")));
                    };
                });
                hxext.ds.Result.Ok(instance);
            };
        };
    };
    public static function variableInlineProcess(arrayContext:litll.idl.litll2entity.LitllToEntityArrayContext):hxext.ds.Result<litll.idl.hxlitll.data.config.ImportConfig, litll.idl.litll2entity.error.LitllToEntityError> return null;
}