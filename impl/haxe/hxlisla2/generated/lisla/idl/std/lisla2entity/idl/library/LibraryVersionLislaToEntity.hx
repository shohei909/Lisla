// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.idl.library;
class LibraryVersionLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.idl.library.LibraryVersion, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> return switch context.lisla.kind {
        case lisla.data.tree.al.AlTreeKind.Arr(array) if (array.length == 2 && array[0].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_ => "version")) && array[1].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("version");
                var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.util.version.VersionLislaToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Error(data):{
                        return hxext.ds.Result.Error(data);
                    };
                };
                hxext.ds.Result.Ok(lisla.idl.std.entity.idl.library.LibraryVersion.Version(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Error(error);
                };
            };
        };
        case data:hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedEnumConstructor(["version"])));
    };
    public static function variableInlineProcess(arrayContext:lisla.idl.lisla2entity.LislaToEntityArrayContext):hxext.ds.Result<lisla.idl.std.entity.idl.library.LibraryVersion, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> return null;
}