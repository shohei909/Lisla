// This file is generated by hxlitll.
package litll.idl.std.litll2backend.core;
class UInt32LitllToBackend {
    public static function process(context:litll.idl.litll2backend.LitllToBackendContext):litll.core.ds.Result<litll.idl.std.data.core.LitllUInt32, litll.idl.litll2backend.LitllToBackendError> {
        return switch (litll.idl.std.litll2backend.core.VariableUIntLitllToBackend.process(context, null)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.LitllUInt32(data);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
}