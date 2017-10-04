// This file is generated by hxarraytree.
package arraytree.idl.std.arraytree2entity.core;
class BigUIntArrayTreeToEntity {
    public static function process(context:arraytree.idl.arraytree2entity.ArrayTreeToEntityContext):hxext.ds.Result<arraytree.idl.std.entity.core.BigUInt, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>> {
        return switch (arraytree.idl.std.arraytree2entity.core.VariableUIntArrayTreeToEntity.process(context, null)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new arraytree.idl.std.entity.core.BigUInt(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Error(data):{
                hxext.ds.Result.Error(data);
            };
        };
    }
}