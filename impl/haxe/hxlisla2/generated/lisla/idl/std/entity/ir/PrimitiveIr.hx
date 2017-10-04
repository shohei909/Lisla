// This file is generated by hxarraytree.
package arraytree.idl.std.entity.ir;
enum PrimitiveIr {
    FixedInt(size:arraytree.idl.std.entity.core.ArrayTreeUInt64, data:arraytree.idl.std.entity.core.BigInt);
    FixedUint(size:arraytree.idl.std.entity.core.ArrayTreeUInt64, data:arraytree.idl.std.entity.core.BigUInt);
    VariableInt(data:arraytree.idl.std.entity.core.BigInt);
    VariableUint(data:arraytree.idl.std.entity.core.BigUInt);
    Float64(data:arraytree.idl.std.entity.core.ArrayTreeFloat64);
    Boolean(data:arraytree.idl.std.entity.core.ArrayTreeBoolean);
    String(data:arraytree.data.meta.core.StringWithMetadata);
    Binary(data:arraytree.idl.std.entity.core.Binary);
}