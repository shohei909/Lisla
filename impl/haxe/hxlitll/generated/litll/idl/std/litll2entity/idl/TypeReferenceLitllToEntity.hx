// This file is generated by hxlitll.
package litll.idl.std.litll2entity.idl;
class TypeReferenceLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.idl.TypeReference, litll.idl.litll2entity.error.LitllToEntityError> return switch context.litll {
        case litll.core.Litll.Str(_):{
            hxext.ds.Result.Ok(litll.idl.std.data.idl.TypeReference.Primitive(switch (litll.idl.std.litll2entity.idl.TypePathLitllToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_))):{
            hxext.ds.Result.Ok(litll.idl.std.data.idl.TypeReference.Generic(switch (litll.idl.std.litll2entity.idl.GenericTypeReferenceLitllToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case data:hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedEnumConstructor([])));
    };
}