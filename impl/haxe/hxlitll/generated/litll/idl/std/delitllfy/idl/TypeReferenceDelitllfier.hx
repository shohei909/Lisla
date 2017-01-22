// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class TypeReferenceDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.TypeReference, litll.idl.delitllfy.DelitllfyError> return switch context.litll {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Ok(litll.idl.std.data.idl.TypeReference.Primitive(switch (litll.idl.std.delitllfy.idl.TypePathDelitllfier.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(error):{
                    return litll.core.ds.Result.Err(error);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.idl.TypeReference.Generic(switch (litll.idl.std.delitllfy.idl.GenericTypeReferenceDelitllfier.process(context)) {
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