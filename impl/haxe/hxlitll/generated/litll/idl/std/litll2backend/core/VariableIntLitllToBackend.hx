// This file is generated by hxlitll.
package litll.idl.std.litll2backend.core;
class VariableIntLitllToBackend {
    public static function process(context:litll.idl.litll2backend.LitllToBackendContext, dependenceBitLength:litll.idl.std.data.core.LitllUInt32):litll.core.ds.Result<litll.idl.std.data.core.VariableInt, litll.idl.litll2backend.LitllToBackendError> {
        return switch (StringLitllToBackend.process(context)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.VariableInt(data, dependenceBitLength);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
}