// This file is generated by hxlitll.
package litll.idl.std.litllToBackend.idl;
class PackagePathLitllToBackend {
    public static function process(context:litll.idl.litllToBackend.LitllToBackendContext):litll.core.ds.Result<litll.idl.std.data.idl.PackagePath, litll.idl.litllToBackend.LitllToBackendError> {
        return switch (StringLitllToBackend.process(context)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    switch (litll.idl.std.data.idl.PackagePath.litllToBackend(data)) {
                        case litll.core.ds.Result.Ok(data):{
                            litll.core.ds.Result.Ok(data);
                        };
                        case litll.core.ds.Result.Err(data):{
                            litll.core.ds.Result.Err(litll.idl.litllToBackend.LitllToBackendError.ofLitll(context.litll, data));
                        };
                    };
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
}