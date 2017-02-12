// This file is generated by hxlitll.
package litll.idl.std.litll2backend.cli.clidl;
class CommandArgumentConfigLitllToBackend {
    public static function process(context:litll.idl.litll2backend.LitllToBackendContext):litll.core.ds.Result<litll.idl.std.data.cli.clidl.CommandArgumentConfig, litll.idl.litll2backend.LitllToBackendError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            litll.core.ds.Result.Err(litll.idl.litll2backend.LitllToBackendError.ofLitll(context.litll, litll.idl.litll2backend.LitllToBackendErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                for (litllData in array.data) {
                    var context = new litll.idl.litll2backend.LitllToBackendContext(litllData, context.config);
                    switch litllData {
                        case litllData:return litll.core.ds.Result.Err(litll.idl.litll2backend.LitllToBackendError.ofLitll(litllData, litll.idl.litll2backend.LitllToBackendErrorKind.UnmatchedStructElement([])));
                    };
                };
                var instance = new litll.idl.std.data.cli.clidl.CommandArgumentConfig(arg0);
                litll.core.ds.Result.Ok(instance);
            };
        };
    };
}