// This file is generated by hxlitll.
package litll.idl.std.litll2entity.idl;
class ArgumentNameLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.idl.ArgumentName, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (StringLitllToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    switch (litll.idl.std.data.idl.ArgumentName.litllToEntity(data)) {
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