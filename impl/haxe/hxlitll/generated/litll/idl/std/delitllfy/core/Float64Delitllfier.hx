// This file is generated by hxlitll.
package litll.idl.std.delitllfy.core;
class Float64Delitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.core.LitllFloat64, litll.idl.delitllfy.DelitllfyError> {
        return switch (StringDelitllfier.process(context)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.LitllFloat64(data);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(error):{
                litll.core.ds.Result.Err(error);
            };
        };
    }
}