// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class TypeDependenceNameDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.TypeDependenceName, litll.idl.delitllfy.DelitllfyError> {
        return switch (StringDelitllfier.process(context)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    switch (litll.idl.std.data.idl.TypeDependenceName.delitllfy(data)) {
                        case litll.core.ds.Result.Ok(ok):{
                            litll.core.ds.Result.Ok(ok);
                        };
                        case litll.core.ds.Result.Err(err):{
                            litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, err));
                        };
                    };
                };
            };
            case litll.core.ds.Result.Err(error):{
                litll.core.ds.Result.Err(error);
            };
        };
    }
}