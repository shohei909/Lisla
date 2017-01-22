// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class EnumConstructorDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.EnumConstructor, litll.idl.delitllfy.DelitllfyError> return switch context.litll {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Ok(litll.idl.std.data.idl.EnumConstructor.Primitive(switch (litll.idl.std.delitllfy.idl.EnumConstructorNameDelitllfier.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(error):{
                    return litll.core.ds.Result.Err(error);
                };
            }));
        };
        case litll.core.Litll.Arr(data) if (1 <= data.length && data.data[0].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.idl.EnumConstructor.Parameterized(switch (litll.idl.std.delitllfy.idl.ParameterizedEnumConstructorDelitllfier.process(context)) {
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