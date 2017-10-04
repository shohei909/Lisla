// This file is generated by hxarraytree.
package arraytree.idl.std.arraytree2entity.core;
class FixedUIntArrayTreeToEntity {
    public static function process(context:arraytree.idl.arraytree2entity.ArrayTreeToEntityContext, dependenceBitLength:arraytree.idl.std.entity.core.ArrayTreeUInt32):hxext.ds.Result<arraytree.idl.std.entity.core.FixedUInt, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>> {
        return switch (arraytree.idl.std.arraytree2entity.StringArrayTreeToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new arraytree.idl.std.entity.core.FixedUInt(data, dependenceBitLength);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Error(data):{
                hxext.ds.Result.Error(data);
            };
        };
    }
}