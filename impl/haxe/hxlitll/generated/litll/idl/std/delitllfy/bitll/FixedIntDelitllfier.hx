// This file is generated by hxlitll.
package litll.idl.std.delitllfy.bitll;
class FixedIntDelitllfier {
    public static function process<T>(context:litll.idl.delitllfy.DelitllfyContext, tProcess:litll.idl.delitllfy.DelitllfyContext -> litll.core.ds.Result<T, litll.idl.delitllfy.DelitllfyError>):litll.core.ds.Result<litll.idl.std.data.bitll.FixedInt<T>, litll.idl.delitllfy.DelitllfyError> {
        return switch (tProcess(context)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.bitll.FixedInt(data);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(error):{
                litll.core.ds.Result.Err(error);
            };
        };
    }
}