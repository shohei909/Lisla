// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class TypeReferenceParameterDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.TypeReferenceParameter, litll.idl.delitllfy.DelitllfyError> {
        return switch (litll.idl.std.delitllfy.core.AnyDelitllfier.process(context)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.idl.TypeReferenceParameter(data);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
}