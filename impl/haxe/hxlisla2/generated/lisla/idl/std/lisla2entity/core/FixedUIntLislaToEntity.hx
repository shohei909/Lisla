// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.core;
class FixedUIntLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext, dependenceBitLength:lisla.idl.std.entity.core.LislaUInt32):hxext.ds.Result<lisla.idl.std.entity.core.FixedUInt, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> {
        return switch (lisla.idl.std.lisla2entity.StringLislaToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new lisla.idl.std.entity.core.FixedUInt(data, dependenceBitLength);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Error(data):{
                hxext.ds.Result.Error(data);
            };
        };
    }
}