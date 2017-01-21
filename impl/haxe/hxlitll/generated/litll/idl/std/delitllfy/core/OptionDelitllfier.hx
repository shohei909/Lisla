// This file is generated by hxlitll.
package litll.idl.std.delitllfy.core;
class OptionDelitllfier {
    public static function process<T>(context:litll.idl.delitllfy.DelitllfyContext, tProcess:litll.idl.delitllfy.DelitllfyContext -> litll.core.ds.Result<T, litll.idl.delitllfy.DelitllfyError>):litll.core.ds.Result<litll.idl.std.data.core.LitllOption<T>, litll.idl.delitllfy.DelitllfyError> return switch context.litll {
        case litll.core.Litll.Arr(data) if (data.length == 0):{
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
            var data = litll.core.ds.Result.Ok(litll.idl.std.data.core.LitllOption.None);
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    litll.core.ds.Result.Err(error);
                };
            };
        };
        case litll.core.Litll.Arr(data) if (data.length == 1):{
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
            var data = {
                var arg0 = switch (arrayContext.read(tProcess)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.core.LitllOption.Some(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    litll.core.ds.Result.Err(error);
                };
            };
        };
        case data:litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor(["none", "some"])));
    };
}