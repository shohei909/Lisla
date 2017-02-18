// This file is generated by hxlitll.
package litll.idl.std.litll2entity.core;
import litll.idl.litll2entity.error.LitllToEntityError;
class FixedIntLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext, dependenceBitLength:litll.idl.std.data.core.LitllUInt32):hxext.ds.Result<litll.idl.std.data.core.FixedInt, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (StringLitllToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.FixedInt(data, dependenceBitLength);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
}