// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.idl;
class TypePathLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.idl.TypePath, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> {
        return switch (lisla.idl.std.lisla2entity.StringLislaToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    switch (lisla.idl.std.entity.idl.TypePath.lislaToEntity(data)) {
                        case hxext.ds.Result.Ok(data):{
                            hxext.ds.Result.Ok(data);
                        };
                        case hxext.ds.Result.Error(data):{
                            hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, data));
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