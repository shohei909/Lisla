// This file is generated by hxlitll.
package litll.idl.std.litll2entity.core;
class FixedArrayLitllToEntity {
    public static function process<T>(context:litll.idl.litll2entity.LitllToEntityContext, tLitllToEntity, dependenceLength:litll.idl.std.data.core.LitllInt64):litll.core.ds.Result<litll.idl.std.data.core.FixedArray<T>, litll.idl.litll2entity.LitllToEntityError> {
        return switch (ArrayLitllToEntity.process(context, tLitllToEntity)) {
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
    public static function fixedInlineProcess<T>(context:litll.idl.litll2entity.LitllToEntityArrayContext, tLitllToEntity, dependenceLength:litll.idl.std.data.core.LitllInt64):litll.core.ds.Result<litll.idl.std.data.core.FixedArray<T>, litll.idl.litll2entity.LitllToEntityError> return null;
    public static function variableInlineProcess<T>(context:litll.idl.litll2entity.LitllToEntityArrayContext, tLitllToEntity, dependenceLength:litll.idl.std.data.core.LitllInt64, tLitllToEntity, dependenceLength:litll.idl.std.data.core.LitllInt64):litll.core.ds.Result<litll.idl.std.data.core.FixedArray<T>, litll.idl.litll2entity.LitllToEntityError> return null;
}