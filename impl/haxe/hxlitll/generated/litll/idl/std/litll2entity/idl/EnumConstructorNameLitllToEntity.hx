// This file is generated by hxlitll.
package litll.idl.std.litll2entity.idl;
class EnumConstructorNameLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.idl.EnumConstructorName, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (litll.idl.std.litll2entity.StringLitllToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    switch (litll.idl.std.data.idl.EnumConstructorName.litllToEntity(data)) {
                        case hxext.ds.Result.Ok(data):{
                            hxext.ds.Result.Ok(data);
                        };
                        case hxext.ds.Result.Err(data):{
                            hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, data));
                        };
                    };
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
}