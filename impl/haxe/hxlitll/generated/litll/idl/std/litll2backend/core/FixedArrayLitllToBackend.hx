// This file is generated by hxlitll.
package litll.idl.std.litll2backend.core;
class FixedArrayLitllToBackend {
    public static function process<T>(context:litll.idl.litll2backend.LitllToBackendContext, tLitllToBackend, dependenceLength:litll.idl.std.data.core.LitllInt64):litll.core.ds.Result<litll.idl.std.data.core.FixedArray<T>, litll.idl.litll2backend.LitllToBackendError> {
        return switch (ArrayLitllToBackend.process(context, tLitllToBackend)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.core.FixedArray(data, dependenceLength);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(data):{
                litll.core.ds.Result.Err(data);
            };
        };
    }
    public static function fixedInlineProcess<T>(context:litll.idl.litll2backend.LitllToBackendArrayContext, tLitllToBackend, dependenceLength:litll.idl.std.data.core.LitllInt64):litll.core.ds.Result<litll.idl.std.data.core.FixedArray<T>, litll.idl.litll2backend.LitllToBackendError> return null;
    public static function variableInlineProcess<T>(context:litll.idl.litll2backend.LitllToBackendArrayContext, tLitllToBackend, dependenceLength:litll.idl.std.data.core.LitllInt64, tLitllToBackend, dependenceLength:litll.idl.std.data.core.LitllInt64):litll.core.ds.Result<litll.idl.std.data.core.FixedArray<T>, litll.idl.litll2backend.LitllToBackendError> return null;
}