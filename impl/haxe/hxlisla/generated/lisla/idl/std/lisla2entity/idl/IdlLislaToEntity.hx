// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.idl;
class IdlLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.idl.Idl, lisla.idl.lisla2entity.error.LislaToEntityError> {
        return switch (context.lisla) {
            case lisla.core.Lisla.Str(_):{
                hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString));
            };
            case lisla.core.Lisla.Arr(array):{
                var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
                var instance = {
                    var arg0 = switch (arrayContext.readWithDefault(lisla.idl.std.lisla2entity.idl.PackageDeclarationLislaToEntity.process, function(data) {
                            return switch data {
                                case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.length <= 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "package"))):true;
                                case _:false;
                            };
                        }, lisla.core.Lisla.Arr(new lisla.core.LislaArray([lisla.core.Lisla.Str(new lisla.core.LislaString("package")), lisla.core.Lisla.Str(new lisla.core.LislaString(""))])))) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Err(data):{
                            return hxext.ds.Result.Err(data);
                        };
                    };
                    var arg1 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.idl.ImportDeclarationLislaToEntity.process, function(data) {
                            return switch data {
                                case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "import")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                                case _:false;
                            };
                        })) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Err(data):{
                            return hxext.ds.Result.Err(data);
                        };
                    };
                    var arg2 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.idl.TypeDefinitionLislaToEntity.process, function(data) {
                            return switch data {
                                case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "newtype"))):true;
                                case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "tuple"))):true;
                                case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "enum"))):true;
                                case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "struct"))):true;
                                case _:false;
                            };
                        })) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Err(data):{
                            return hxext.ds.Result.Err(data);
                        };
                    };
                    var instance = new lisla.idl.std.entity.idl.Idl(arg0, arg1, arg2);
                    hxext.ds.Result.Ok(instance);
                };
                switch (arrayContext.closeOrError()) {
                    case haxe.ds.Option.None:{
                        instance;
                    };
                    case haxe.ds.Option.Some(data):{
                        hxext.ds.Result.Err(data);
                    };
                };
            };
        };
    }
    public static function variableInlineProcess(arrayContext:lisla.idl.lisla2entity.LislaToEntityArrayContext):hxext.ds.Result<lisla.idl.std.entity.idl.Idl, lisla.idl.lisla2entity.error.LislaToEntityError> return null;
}