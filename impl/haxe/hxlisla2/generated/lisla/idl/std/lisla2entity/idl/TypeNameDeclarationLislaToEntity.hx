// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.idl;
class TypeNameDeclarationLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.idl.TypeNameDeclaration, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> return switch context.lisla.kind {
        case lisla.data.tree.al.AlTreeKind.Leaf(_):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.idl.TypeNameDeclaration.Primitive(switch (lisla.idl.std.lisla2entity.idl.TypeNameLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Error(data):{
                    return hxext.ds.Result.Error(data);
                };
            }));
        };
        case lisla.data.tree.al.AlTreeKind.Arr(array) if (1 <= array.length && array[0].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.idl.TypeNameLislaToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Error(data):{
                        return hxext.ds.Result.Error(data);
                    };
                };
                var arg1 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.idl.TypeParameterDeclarationLislaToEntity.process, function(data) {
                        return switch data.kind {
                            case lisla.data.tree.al.AlTreeKind.Leaf(_):true;
                            case lisla.data.tree.al.AlTreeKind.Arr(array) if (array.length == 2 && array[0].kind.match(lisla.data.tree.al.AlTreeKind.Leaf(_))):true;
                            case _:false;
                        };
                    })) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Error(data):{
                        return hxext.ds.Result.Error(data);
                    };
                };
                hxext.ds.Result.Ok(lisla.idl.std.entity.idl.TypeNameDeclaration.Generic(arg0, arg1));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Error(error);
                };
            };
        };
        case data:hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedEnumConstructor(["generic"])));
    };
}