// This file is generated by hxarraytree.
package arraytree.idl.std.arraytree2entity.idl;
class TypeDependenceNameArrayTreeToEntity {
    public static function process(context:arraytree.idl.arraytree2entity.ArrayTreeToEntityContext):hxext.ds.Result<arraytree.idl.std.entity.idl.TypeDependenceName, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>> {
        return switch (arraytree.idl.std.arraytree2entity.StringArrayTreeToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    switch (arraytree.idl.std.entity.idl.TypeDependenceName.arraytreeToEntity(data)) {
                        case hxext.ds.Result.Ok(data):{
                            hxext.ds.Result.Ok(data);
                        };
                        case hxext.ds.Result.Error(data):{
                            hxext.ds.Result.Error(arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError.ofArrayTree(context.arraytree, data));
                        };
                    };
                };
            };
            case hxext.ds.Result.Error(data):{
                hxext.ds.Result.Error(data);
            };
        };
    }
}