// This file is generated by hxlitll.
package litll.idl.std.litllToBackend.cli.clidl;
class SubcommandConfigLitllToBackend {
    public static function process(context:litll.idl.litllToBackend.LitllToBackendContext):litll.core.ds.Result<litll.idl.std.data.cli.clidl.SubcommandConfig, litll.idl.litllToBackend.LitllToBackendError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Err(litll.idl.litllToBackend.LitllToBackendError.ofLitll(context.litll, litll.idl.litllToBackend.LitllToBackendErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                for (litllData in array.data) {
                    var context = new litll.idl.litllToBackend.LitllToBackendContext(litllData, context.config);
                    switch litllData {
                        case litllData:return litll.core.ds.Result.Err(litll.idl.litllToBackend.LitllToBackendError.ofLitll(litllData, litll.idl.litllToBackend.LitllToBackendErrorKind.UnmatchedStructElement([])));
                    };
                };
                var instance = new litll.idl.std.data.cli.clidl.SubcommandConfig();
                litll.core.ds.Result.Ok(instance);
            };
        };
    };
}