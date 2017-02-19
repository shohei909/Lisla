// This file is generated by hxlitll.
package litll.idl.std.litll2entity.cli.clidl;
class CommonConfigLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.cli.clidl.CommonConfig, litll.idl.litll2entity.error.LitllToEntityError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                var arg1 = [];
                var arg2 = [];
                var arg3 = [];
                for (litllData in array.data) {
                    var context = new litll.idl.litll2entity.LitllToEntityContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "description")) && array.data[1].match(litll.core.Litll.Str(_))):switch (arg0) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementDuplicated("description")));
                            };
                            case haxe.ds.Option.None:{
                                arg0 = haxe.ds.Option.Some({
                                    var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
                                    switch (litll.idl.std.litll2entity.StringLitllToEntity.process(context)) {
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
                        case litll.core.Litll.Arr(array) if (2 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "subcommand")) && array.data[1].match(litll.core.Litll.Str(_))):arg1.push(switch (litll.idl.std.litll2entity.cli.clidl.SubcommandLitllToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Err(data):{
                                return hxext.ds.Result.Err(data);
                            };
                        });
                        case litll.core.Litll.Arr(array) if (2 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "arg")) && array.data[1].match(litll.core.Litll.Str(_))):arg2.push(switch (litll.idl.std.litll2entity.cli.clidl.CommandArgumentLitllToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Err(data):{
                                return hxext.ds.Result.Err(data);
                            };
                        });
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "input")) && array.data[1].match(litll.core.Litll.Str(_.data => "TypeReference"))):arg3.push(switch (litll.idl.std.litll2entity.cli.clidl.CommandInputLitllToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Err(data):{
                                return hxext.ds.Result.Err(data);
                            };
                        });
                        case litllData:return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedStructElement(["description", "subcommand", "arg", "input"])));
                    };
                };
                var instance = new litll.idl.std.data.cli.clidl.CommonConfig(arg0, arg1, arg2, arg3);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
}