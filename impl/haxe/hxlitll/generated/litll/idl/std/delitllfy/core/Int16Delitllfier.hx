// This file is generated by hxlitll.
package litll.idl.std.delitllfy.core;
class Int16Delitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.core.LitllInt16, litll.idl.delitllfy.DelitllfyError> {
        return switch (litll.idl.std.delitllfy.core.FixedIntDelitllfier.process(context, null)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.LitllInt16(data);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
}