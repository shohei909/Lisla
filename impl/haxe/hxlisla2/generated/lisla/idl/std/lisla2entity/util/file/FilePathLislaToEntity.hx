// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.util.file;
class FilePathLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.util.file.FilePath, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> {
        return switch (lisla.idl.std.lisla2entity.StringLislaToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new lisla.idl.std.entity.util.file.FilePath(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Error(data):{
                hxext.ds.Result.Error(data);
            };
        };
    }
}