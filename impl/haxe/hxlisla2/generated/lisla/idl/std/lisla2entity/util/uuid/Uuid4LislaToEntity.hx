// This file is generated by hxarraytree.
package arraytree.idl.std.arraytree2entity.util.uuid;
class Uuid4ArrayTreeToEntity {
    public static function process(context:arraytree.idl.arraytree2entity.ArrayTreeToEntityContext):hxext.ds.Result<arraytree.idl.std.entity.util.uuid.Uuid4, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>> {
        return switch (arraytree.idl.std.arraytree2entity.StringArrayTreeToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new arraytree.idl.std.entity.util.uuid.Uuid4(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Error(data):{
                hxext.ds.Result.Error(data);
            };
        };
    }
}