// This file is generated by hxlitll.
package litll.idl.std.delitllfy.core;
class MapDelitllfier {
    public static function process<K, V>(context:litll.idl.delitllfy.DelitllfyContext, kDelitllfier, vDelitllfier):litll.core.ds.Result<litll.idl.std.data.core.LitllMap<K, V>, litll.idl.delitllfy.DelitllfyError> {
        return switch (ArrayDelitllfier.process(context, litll.idl.std.delitllfy.core.PairDelitllfier)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.LitllMap(data);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
    public static function fixedInlineProcess<K, V>(context:litll.idl.delitllfy.DelitllfyArrayContext, kDelitllfier, vDelitllfier):litll.core.ds.Result<litll.idl.std.data.core.LitllMap<K, V>, litll.idl.delitllfy.DelitllfyError> return null;
    public static function valiableInlineProcess<K, V>(context:litll.idl.delitllfy.DelitllfyArrayContext, kDelitllfier, vDelitllfier, kDelitllfier, vDelitllfier):litll.core.ds.Result<litll.idl.std.data.core.LitllMap<K, V>, litll.idl.delitllfy.DelitllfyError> return null;
}