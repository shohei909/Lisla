// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class TupleElementDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.TupleElement, litll.idl.delitllfy.DelitllfyError> return switch context.litll {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Ok(litll.idl.std.data.idl.TupleElement.Label(switch (StringDelitllfier.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (2 <= array.length && array.length <= 3 && array.data[0].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.idl.TupleElement.Argument(switch (litll.idl.std.delitllfy.idl.ArgumentDelitllfier.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case data:litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor([])));
    };
}