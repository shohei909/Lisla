// This file is generated by hxlitll.
package litll.idl.std.litll2entity.idl.library;
class LibraryVersionLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.idl.library.LibraryVersion, litll.idl.litll2entity.LitllToEntityError> return switch context.litll {
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "version")) && array.data[1].match(litll.core.Litll.Str(_.data => "Version"))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = hxext.ds.Result.Ok(litll.idl.std.data.idl.library.LibraryVersion.Version);
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Err(error);
                };
            };
        };
        case data:hxext.ds.Result.Err(litll.idl.litll2entity.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.LitllToEntityErrorKind.UnmatchedEnumConstructor(["version"])));
    };
}