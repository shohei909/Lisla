// This file is generated by hxlitll.
package litll.idl.std.delitllfy.core;
class FixedIntDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext, dependenceBitLength:litll.idl.std.data.core.LitllUInt64):litll.core.ds.Result<litll.idl.std.data.core.FixedInt, litll.idl.delitllfy.DelitllfyError> {
        return switch (StringDelitllfier.process(context)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.FixedInt(data, dependenceBitLength);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
}