// This file is generated by hxlitll.
package litll.idl.std.litll2entity.idl.portable;
class PortableIdlLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.idl.portable.PortableIdl, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (litll.idl.std.litll2entity.ArrayLitllToEntity.process(context, litll.idl.std.litll2entity.idl.portable.PortableIdlElementLitllToEntity)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.idl.portable.PortableIdl(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
    public static function variableInlineProcess(arrayContext:litll.idl.litll2entity.LitllToEntityArrayContext):hxext.ds.Result<litll.idl.std.data.idl.portable.PortableIdl, litll.idl.litll2entity.error.LitllToEntityError> return null;
}