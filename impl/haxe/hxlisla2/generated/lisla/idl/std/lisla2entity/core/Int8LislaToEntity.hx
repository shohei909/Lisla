// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.core;
class Int8LislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.core.LislaInt8, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> {
        return switch (lisla.idl.std.lisla2entity.core.FixedIntLislaToEntity.process(context, null)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new lisla.idl.std.entity.core.LislaInt8(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Error(data):{
                hxext.ds.Result.Error(data);
            };
        };
    }
}