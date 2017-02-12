// This file is generated by hxlitll.
package litll.idl.std.litllToBackend.core;
class MapLitllToBackend {
    public static function process<K, V>(context:litll.idl.litllToBackend.LitllToBackendContext, kLitllToBackend, vLitllToBackend):litll.core.ds.Result<litll.idl.std.data.core.LitllMap<K, V>, litll.idl.litllToBackend.LitllToBackendError> {
        return switch (ArrayLitllToBackend.process(context, litll.idl.std.litllToBackend.core.PairLitllToBackend)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.LitllMap(data);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
    public static function fixedInlineProcess<K, V>(context:litll.idl.litllToBackend.LitllToBackendArrayContext, kLitllToBackend, vLitllToBackend):litll.core.ds.Result<litll.idl.std.data.core.LitllMap<K, V>, litll.idl.litllToBackend.LitllToBackendError> return null;
    public static function variableInlineProcess<K, V>(context:litll.idl.litllToBackend.LitllToBackendArrayContext, kLitllToBackend, vLitllToBackend, kLitllToBackend, vLitllToBackend):litll.core.ds.Result<litll.idl.std.data.core.LitllMap<K, V>, litll.idl.litllToBackend.LitllToBackendError> return null;
}