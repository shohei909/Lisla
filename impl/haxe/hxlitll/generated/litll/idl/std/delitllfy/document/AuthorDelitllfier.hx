// This file is generated by hxlitll.
package litll.idl.std.delitllfy.document;
class AuthorDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.document.Author, litll.idl.delitllfy.DelitllfyError> {
        return switch (StringDelitllfier.process(context)) {
            case litll.core.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.document.Author(data);
                    litll.core.ds.Result.Ok(instance);
                };
            };
            case litll.core.ds.Result.Err(error):{
                litll.core.ds.Result.Err(error);
            };
        };
    }
}