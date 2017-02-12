// This file is generated by hxlitll.
package litll.idl.std.delitllfy.cli.clidl;
class SubcommandDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.cli.clidl.Subcommand, litll.idl.delitllfy.DelitllfyError> {
        return switch (context.litll) {
            case litll.core.Litll.Str(_):{
                litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.CantBeString));
            };
            case litll.core.Litll.Arr(data):{
                var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
                var instance = {
                    arrayContext.readLabel("subcommand");
                    var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.cli.clidl.CommandNameDelitllfier.process)) {
                        case litll.core.ds.Result.Ok(data):{
                            data;
                        };
                        case litll.core.ds.Result.Err(data):{
                            return litll.core.ds.Result.Err(data);
                        };
                    };
                    var arg1 = switch (arrayContext.readFixedInline(litll.idl.std.delitllfy.cli.clidl.SubcommandConfigDelitllfier.fixedInlineProcess, arrayContext.length - 0)) {
                        case litll.core.ds.Result.Ok(data):{
                            data;
                        };
                        case litll.core.ds.Result.Err(data):{
                            return litll.core.ds.Result.Err(data);
                        };
                    };
                    var instance = new litll.idl.std.data.cli.clidl.Subcommand(arg0, arg1);
                    litll.core.ds.Result.Ok(instance);
                };
                switch (arrayContext.closeOrError()) {
                    case haxe.ds.Option.None:{
                        instance;
                    };
                    case haxe.ds.Option.Some(data):{
                        litll.core.ds.Result.Err(data);
                    };
                };
            };
        };
    }
    public static function fixedInlineProcess(context:litll.idl.delitllfy.DelitllfyArrayContext):litll.core.ds.Result<litll.idl.std.data.cli.clidl.Subcommand, litll.idl.delitllfy.DelitllfyError> return null;
    public static function valiableInlineProcess(context:litll.idl.delitllfy.DelitllfyArrayContext):litll.core.ds.Result<litll.idl.std.data.cli.clidl.Subcommand, litll.idl.delitllfy.DelitllfyError> return null;
}