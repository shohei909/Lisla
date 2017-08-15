// This file is generated by hxlisla.
package lisla.idl.hxlisla.lisla2entity;
class ImportDeclarationLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.hxlisla.entity.ImportDeclaration, lisla.idl.lisla2entity.error.LislaToEntityError> {
        return switch (context.lisla) {
            case lisla.core.Lisla.Str(_):{
                hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString));
            };
            case lisla.core.Lisla.Arr(array):{
                var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
                var instance = {
                    arrayContext.readLabel("import");
                    var arg0 = switch (arrayContext.readFixedInline(lisla.idl.hxlisla.lisla2entity.ImportConfigLislaToEntity.process, arrayContext.length - 0)) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Err(data):{
                            return hxext.ds.Result.Err(data);
                        };
                    };
                    var instance = new lisla.idl.hxlisla.entity.ImportDeclaration(arg0);
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
    public static function variableInlineProcess(arrayContext:lisla.idl.lisla2entity.LislaToEntityArrayContext):hxext.ds.Result<lisla.idl.hxlisla.entity.ImportDeclaration, lisla.idl.lisla2entity.error.LislaToEntityError> return null;
}