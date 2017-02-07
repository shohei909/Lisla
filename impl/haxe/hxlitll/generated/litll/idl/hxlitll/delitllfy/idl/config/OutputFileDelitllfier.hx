// This file is generated by hxlitll.
package litll.idl.hxlitll.delitllfy.idl.config;
class OutputFileDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.hxlitll.data.idl.config.OutputFile, litll.idl.delitllfy.DelitllfyError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                var arg1 = haxe.ds.Option.None;
                for (litllData in array.data) {
                    var context = new litll.idl.delitllfy.DelitllfyContext(litllData, context.config);
                    switch litllData {
                        case litll.core.Litll.Arr(array) if (2 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "target")) && array.data[1].match(litll.core.Litll.Str(_))):switch (arg0) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litllData, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDuplicated("target")));
                            };
                            case haxe.ds.Option.None:{
                                arg0 = haxe.ds.Option.Some(switch (litll.idl.hxlitll.delitllfy.idl.config.TargetTupleDelitllfier.process(context)) {
                                    case litll.core.ds.Result.Ok(data):{
                                        data;
                                    };
                                    case litll.core.ds.Result.Err(data):{
                                        return litll.core.ds.Result.Err(data);
                                    };
                                });
                            };
                        };
                        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "filter")) && array.data[1].match(litll.core.Litll.Arr(_))):switch (arg1) {
                            case haxe.ds.Option.Some(_):{
                                return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(litllData, litll.idl.delitllfy.DelitllfyErrorKind.StructElementDuplicated("filter")));
                            };
                            case haxe.ds.Option.None:{
                                arg1 = haxe.ds.Option.Some({
                                    var context = new litll.idl.delitllfy.DelitllfyContext(array.data[1], context.config);
                                    switch (litll.idl.hxlitll.delitllfy.idl.config.FilterTupleDelitllfier.process(context)) {
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
                var instance = new litll.idl.hxlitll.data.idl.config.OutputFile(switch (arg0) {
                    case haxe.ds.Option.Some(data):{
                        data;
                    };
                    case haxe.ds.Option.None:{
                        return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.StructElementNotFound("target")));
                    };
                }, switch (arg1) {
                    case haxe.ds.Option.Some(data):{
                        data;
                    };
                    case haxe.ds.Option.None:{
                        return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.StructElementNotFound("filter")));
                    };
                });
                litll.core.ds.Result.Ok(instance);
            };
        };
    };
}