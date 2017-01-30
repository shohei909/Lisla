// This file is generated by hxlitll.
package litll.idl.std.delitllfy.cli.clidl;
class CommonConfigDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.cli.clidl.CommonConfig, litll.idl.delitllfy.DelitllfyError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                var arg1 = haxe.ds.Option.None;
                var arg2 = haxe.ds.Option.None;
                var arg3 = haxe.ds.Option.None;
                for (litllData in array.data) {
                    var context = new litll.idl.delitllfy.DelitllfyContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "description")) && array.data[1].match(litll.core.Litll.Str(_))):switch (arg0) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litllData, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDupplicated("description")));
                            };
                            case haxe.ds.Option.None:{
                                arg0 = haxe.ds.Option.Some({
                                    var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                                    switch (StringDelitllfier.process(context)) {
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
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "subcommand")) && array.data[1].match(litll.core.Litll.Arr(_))):switch (arg1) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litllData, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDupplicated("subcommand")));
                            };
                            case haxe.ds.Option.None:{
                                arg1 = haxe.ds.Option.Some({
                                    var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                                    switch (litll.idl.std.delitllfy.cli.clidl.SubcommandDelitllfier.process(context)) {
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
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "arg")) && array.data[1].match(litll.core.Litll.Arr(_))):switch (arg2) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litllData, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDupplicated("arg")));
                            };
                            case haxe.ds.Option.None:{
                                arg2 = haxe.ds.Option.Some({
                                    var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                                    switch (litll.idl.std.delitllfy.cli.clidl.CommandArgumentDelitllfier.process(context)) {
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
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "input")) && array.data[1].match(litll.core.Litll.Arr(_))):switch (arg3) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litllData, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDupplicated("input")));
                            };
                            case haxe.ds.Option.None:{
                                arg3 = haxe.ds.Option.Some({
                                    var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                                    switch (litll.idl.std.delitllfy.cli.clidl.CommandInputDelitllfier.process(context)) {
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
                var instance = new litll.idl.std.data.cli.clidl.CommonConfig(arg0, switch (arg1) {
                    case haxe.ds.Option.Some(data):{
                        data;
                    };
                    case haxe.ds.Option.None:{
                        return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.StructElementNotFound("subcommand")));
                    };
                }, switch (arg2) {
                    case haxe.ds.Option.Some(data):{
                        data;
                    };
                    case haxe.ds.Option.None:{
                        return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.StructElementNotFound("arg")));
                    };
                }, switch (arg3) {
                    case haxe.ds.Option.Some(data):{
                        data;
                    };
                    case haxe.ds.Option.None:{
                        return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.StructElementNotFound("input")));
                    };
                });
                litll.core.ds.Result.Ok(instance);
            };
        };
    };
}