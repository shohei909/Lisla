// This file is generated by hxlitll.
package litll.idl.std.litll2backend.core;
class BooleanLitllToBackend {
    public static function process(context:litll.idl.litll2backend.LitllToBackendContext):litll.core.ds.Result<litll.idl.std.data.core.LitllBoolean, litll.idl.litll2backend.LitllToBackendError> return switch context.litll {
        case litll.core.Litll.Str(data) if (data.data == "true"):litll.core.ds.Result.Ok(litll.idl.std.data.core.LitllBoolean.True);
        case litll.core.Litll.Str(data) if (data.data == "false"):litll.core.ds.Result.Ok(litll.idl.std.data.core.LitllBoolean.False);
        case data:litll.core.ds.Result.Err(litll.idl.litll2backend.LitllToBackendError.ofLitll(context.litll, litll.idl.litll2backend.LitllToBackendErrorKind.UnmatchedEnumConstructor(["true", "false"])));
    };
}