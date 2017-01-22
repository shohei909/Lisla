// This file is generated by hxlitll.
package litll.idl.std.delitllfy.document;
class HeaderDocumentDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.document.HeaderDocument, litll.idl.delitllfy.DelitllfyError> return switch (context.litll) {
        case litll.core.Litll.Str(string):{
            litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.CantBeString));
        };
        case litll.core.Litll.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                var arg1 = [];
                var arg2 = [];
                var arg3 = haxe.ds.Option.None;
                for (data in array.data) switch data {
                    case litll.core.Litll.Arr(data) if (data.length == 2 && data.data[0].match(litll.core.Litll.Str(_.data => "encoding")) && data.data[1].match(litll.core.Litll.Str(_.data => "utf8"))):null;
                    case litll.core.Litll.Arr(data) if (data.length == 2 && data.data[0].match(litll.core.Litll.Str(_.data => "license")) && data.data[1].match(litll.core.Litll.Str(_))):null;
                    case litll.core.Litll.Arr(data) if (data.length == 2 && data.data[0].match(litll.core.Litll.Str(_.data => "author")) && data.data[1].match(litll.core.Litll.Str(_))):null;
                    case litll.core.Litll.Arr(data) if (data.length == 2 && data.data[0].match(litll.core.Litll.Str(_.data => "schema"))):null;
                    case data:return litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedStructElement([])));
                };
                var instance = new litll.idl.std.data.document.HeaderDocument(arg0, arg1, arg2, arg3);
                litll.core.ds.Result.Ok(instance);
            };
        };
    };
}