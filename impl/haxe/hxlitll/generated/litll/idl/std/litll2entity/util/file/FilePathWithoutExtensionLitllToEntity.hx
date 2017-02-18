// This file is generated by hxlitll.
package litll.idl.std.litll2entity.util.file;
import litll.idl.litll2entity.error.LitllToEntityError;
class FilePathWithoutExtensionLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext, dependenceExtensions:litll.core.LitllArray<litll.idl.std.data.util.file.FileExtension>):hxext.ds.Result<litll.idl.std.data.util.file.FilePathWithoutExtension, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (StringLitllToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.data.util.file.FilePathWithoutExtension(data, dependenceExtensions);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
}