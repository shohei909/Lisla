// This file is generated by hxlitll.
package litll.idl.std.litll2entity.core;
class VariableIntLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext, dependenceBitLength:litll.idl.std.entity.core.LitllUInt32):hxext.ds.Result<litll.idl.std.entity.core.VariableInt, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (litll.idl.std.litll2entity.StringLitllToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.entity.core.VariableInt(data, dependenceBitLength);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
}