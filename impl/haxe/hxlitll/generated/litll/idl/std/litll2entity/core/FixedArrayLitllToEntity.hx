// This file is generated by hxlitll.
package litll.idl.std.litll2entity.core;
class FixedArrayLitllToEntity {
    public static function process<T>(context:litll.idl.litll2entity.LitllToEntityContext, tLitllToEntity, dependenceLength:litll.idl.std.data.core.LitllInt64):hxext.ds.Result<litll.idl.std.data.core.FixedArray<T>, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (litll.idl.std.litll2entity.ArrayLitllToEntity.process(context, tLitllToEntity)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.FixedArray(data, dependenceLength);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
    public static function variableInlineProcess<T>(arrayContext:litll.idl.litll2entity.LitllToEntityArrayContext, tLitllToEntity, dependenceLength:litll.idl.std.data.core.LitllInt64, tLitllToEntity, dependenceLength:litll.idl.std.data.core.LitllInt64):hxext.ds.Result<litll.idl.std.data.core.FixedArray<T>, litll.idl.litll2entity.error.LitllToEntityError> return null;
}