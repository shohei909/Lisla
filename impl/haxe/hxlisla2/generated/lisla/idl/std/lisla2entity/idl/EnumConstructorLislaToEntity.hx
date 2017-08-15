// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.idl;
class EnumConstructorLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.idl.EnumConstructor, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> return switch context.lisla.kind {
        case lisla.data.tree.al.AlTreeKind.Leaf(_):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.idl.EnumConstructor.Primitive(switch (lisla.idl.std.lisla2entity.idl.EnumConstructorNameLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Error(data):{
                    return hxext.ds.Result.Error(data);
                };
            }));
        };
        case lisla.data.tree.al.AlTreeKind.Arr(array) if (1 <= array.length && array[0].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_))):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.idl.EnumConstructor.Parameterized(switch (lisla.idl.std.lisla2entity.idl.ParameterizedEnumConstructorLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Error(data):{
                    return hxext.ds.Result.Error(data);
                };
            }));
        };
        case data:hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedEnumConstructor([])));
    };
}