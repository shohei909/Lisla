// This file is generated by hxlitll.
package litll.idl.std.litll2entity.document;
class DocumentEncodingLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.document.DocumentEncoding, litll.idl.litll2entity.LitllToEntityError> return switch context.litll {
        case litll.core.Litll.Str(data) if (data.data == "utf8"):hxext.ds.Result.Ok(litll.idl.std.data.document.DocumentEncoding.Utf8);
        case data:hxext.ds.Result.Err(litll.idl.litll2entity.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.LitllToEntityErrorKind.UnmatchedEnumConstructor(["utf8"])));
    };
}