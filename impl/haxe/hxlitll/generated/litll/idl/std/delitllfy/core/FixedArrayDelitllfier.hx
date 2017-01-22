// This file is generated by hxlitll.
package litll.idl.std.delitllfy.core;
class FixedArrayDelitllfier {
    public static function process<T>(context:litll.idl.delitllfy.DelitllfyContext, tProcess:litll.idl.delitllfy.DelitllfyContext -> litll.core.ds.Result<T, litll.idl.delitllfy.DelitllfyError>, dependenceLength:Int):litll.core.ds.Result<litll.idl.std.data.core.FixedArray<T>, litll.idl.delitllfy.DelitllfyError> {
        return switch (ArrayDelitllfier.process(context, TDelitllfier.process)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.FixedArray(data, dependenceLength);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
}