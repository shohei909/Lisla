// This file is generated by hxlitll.
package litll.idl.std.litll2entity.util.file;
class FilePathWithExtensionLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext, dependenceExtensions:litll.core.LitllArray<litll.idl.std.data.util.file.FileExtension>):hxext.ds.Result<litll.idl.std.data.util.file.FilePathWithExtension, litll.idl.litll2entity.LitllToEntityError> {
        return switch (StringLitllToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.util.file.FilePathWithExtension(data, dependenceExtensions);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
}