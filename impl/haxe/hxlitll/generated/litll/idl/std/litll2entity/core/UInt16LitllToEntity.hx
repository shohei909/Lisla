// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.core;
class UInt16LislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.core.LislaUInt16, lisla.idl.lisla2entity.error.LislaToEntityError> {
        return switch (lisla.idl.std.lisla2entity.core.FixedUIntLislaToEntity.process(context, null)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new lisla.idl.std.entity.core.LislaUInt16(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
}