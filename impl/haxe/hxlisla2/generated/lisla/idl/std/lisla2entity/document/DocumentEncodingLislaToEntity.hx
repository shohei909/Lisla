// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.document;
class DocumentEncodingLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.document.DocumentEncoding, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> return switch context.lisla.kind {
        case lisla.data.tree.al.AlTreeKind.Leaf(data) if (data.data == "utf8"):hxext.ds.Result.Ok(lisla.idl.std.entity.document.DocumentEncoding.Utf8);
        case data:hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedEnumConstructor(["utf8"])));
    };
}