// This file is generated by hxlitll.
package litll.idl.std.litll2entity.idl;
class TypeDependenceNameLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.idl.TypeDependenceName, litll.idl.litll2entity.LitllToEntityError> {
        return switch (StringLitllToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    switch (litll.idl.std.data.idl.TypeDependenceName.litllToEntity(data)) {
                        case hxext.ds.Result.Ok(data):{
                            hxext.ds.Result.Ok(data);
                        };
                        case hxext.ds.Result.Err(data):{
                            hxext.ds.Result.Err(litll.idl.litll2entity.LitllToEntityError.ofLitll(context.litll, data));
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