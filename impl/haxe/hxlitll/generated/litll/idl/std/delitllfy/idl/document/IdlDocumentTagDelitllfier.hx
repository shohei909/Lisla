// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl.document;
class IdlDocumentTagDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.document.IdlDocumentTag, litll.idl.delitllfy.DelitllfyError> return switch context.litll {
        case litll.core.Litll.Arr(data) if (data.length == 2 && data.data[0].match(litll.core.Litll.Str(_.data => "repath"))):{
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
            var data = {
                arrayContext.readLabel("repath");
                var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.file.FilePathDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.idl.document.IdlDocumentTag.Repath(arg0));
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
        case data:litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor(["repath"])));
    };
}