// This file is generated by hxarraytree.
package arraytree.idl.std.arraytree2entity.util.file;
class FileOrDirectoryPathArrayTreeToEntity {
    public static function process(context:arraytree.idl.arraytree2entity.ArrayTreeToEntityContext):hxext.ds.Result<arraytree.idl.std.entity.util.file.FileOrDirectoryPath, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>> {
        return switch (arraytree.idl.std.arraytree2entity.StringArrayTreeToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new arraytree.idl.std.entity.util.file.FileOrDirectoryPath(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Error(data):{
                hxext.ds.Result.Error(data);
            };
        };
    }
}