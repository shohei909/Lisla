// This file is generated by hxlitll.
package litll.idl.std.litll2backend.document;
class LicenseLitllToBackend {
    public static function process(context:litll.idl.litll2backend.LitllToBackendContext):litll.core.ds.Result<litll.idl.std.data.document.License, litll.idl.litll2backend.LitllToBackendError> {
        return switch (StringLitllToBackend.process(context)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.document.License(data);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
}