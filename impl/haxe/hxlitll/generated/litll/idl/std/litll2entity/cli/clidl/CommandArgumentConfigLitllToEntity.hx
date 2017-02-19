// This file is generated by hxlitll.
package litll.idl.std.litll2entity.cli.clidl;
class CommandArgumentConfigLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.cli.clidl.CommandArgumentConfig, litll.idl.litll2entity.error.LitllToEntityError> return switch (context.litll) {
        case litll.core.Litll.Str(_):{
            hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                for (litllData in array.data) {
                    var context = new litll.idl.litll2entity.LitllToEntityContext(litllData, context.config);
                    switch litllData {
                        case litllData:return hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(litllData, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedStructElement([])));
                    };
                };
                var instance = new litll.idl.std.data.cli.clidl.CommandArgumentConfig(arg0);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
    public static function fixedInlineProcess(context:litll.idl.litll2entity.LitllToEntityArrayContext):hxext.ds.Result<litll.idl.std.data.cli.clidl.CommandArgumentConfig, litll.idl.litll2entity.error.LitllToEntityError> return null;
}