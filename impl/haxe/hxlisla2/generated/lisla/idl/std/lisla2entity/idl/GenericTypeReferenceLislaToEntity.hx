// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.idl;
class GenericTypeReferenceLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.idl.GenericTypeReference, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> {
        return switch (context.lisla.kind) {
            case lisla.data.tree.al.AlTreeKind.Leaf(_):{
                hxext.ds.Result.Error(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString));
            };
            case lisla.data.tree.al.AlTreeKind.Arr(array):{
                var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
                var instance = {
                    var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.idl.TypePathLislaToEntity.process)) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Error(data):{
                            return hxext.ds.Result.Error(data);
                        };
                    };
                    var arg1 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.idl.TypeReferenceParameterLislaToEntity.process, function(data) {
                            return switch data.kind {
                                case lisla.data.tree.al.AlTreeKind.Leaf(_):true;
                                case lisla.data.tree.al.AlTreeKind.Arr(array):true;
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
                    var instance = new lisla.idl.std.entity.idl.GenericTypeReference(arg0, arg1);
                    hxext.ds.Result.Ok(instance);
                };
                switch (arrayContext.closeOrError()) {
                    case haxe.ds.Option.None:{
                        instance;
                    };
                    case haxe.ds.Option.Some(data):{
                        hxext.ds.Result.Error(data);
                    };
                };
            };
        };
    }
    public static function variableInlineProcess(arrayContext:lisla.idl.lisla2entity.LislaToEntityArrayContext):hxext.ds.Result<lisla.idl.std.entity.idl.GenericTypeReference, Array<lisla.idl.lisla2entity.error.LislaToEntityError>> return null;
}