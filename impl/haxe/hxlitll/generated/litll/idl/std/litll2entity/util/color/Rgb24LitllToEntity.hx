// This file is generated by hxlitll.
package litll.idl.std.litll2entity.util.color;
import litll.idl.litll2entity.error.LitllToEntityError;
class Rgb24LitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.util.color.Rgb24, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (litll.idl.std.litll2entity.core.FixedUIntLitllToEntity.process(context, null)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.util.color.Rgb24(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
}