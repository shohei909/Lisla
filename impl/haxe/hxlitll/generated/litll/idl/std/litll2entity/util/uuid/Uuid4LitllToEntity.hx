// This file is generated by hxlitll.
package litll.idl.std.litll2entity.util.uuid;
class Uuid4LitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.util.uuid.Uuid4, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (StringLitllToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.util.uuid.Uuid4(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
}