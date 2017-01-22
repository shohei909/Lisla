// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class PackageDeclarationDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.PackageDeclaration, litll.idl.delitllfy.DelitllfyError> return switch context.litll {
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "package")) && array.data[1].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("package");
                var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.PackagePathDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(data):{
                        return litll.core.ds.Result.Err(data);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.idl.PackageDeclaration.Package(arg0));
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
        case data:litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor(["package"])));
    };
}