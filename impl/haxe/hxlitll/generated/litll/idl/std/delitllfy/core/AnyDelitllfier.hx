// This file is generated by hxlitll.
package litll.idl.std.delitllfy.core;
class AnyDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.core.Litll, litll.idl.delitllfy.DelitllfyError> return switch context.litll {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Ok(litll.core.Litll.Str(switch (StringDelitllfier.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(error):{
                    return litll.core.ds.Result.Err(error);
                };
            }));
        };
        case litll.core.Litll.Arr(_):{
            litll.core.ds.Result.Ok(litll.core.Litll.Arr(switch (ArrayDelitllfier.process(context, litll.idl.std.delitllfy.core.AnyDelitllfier.process)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(error):{
                    return litll.core.ds.Result.Err(error);
                };
            }));
        };
        case data:litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor([])));
    };
}