// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.xml.lixml;
class LixmlAttributeLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.xml.lixml.LixmlAttribute, lisla.idl.lisla2entity.error.LislaToEntityError> {
        return switch (context.lisla) {
            case lisla.core.Lisla.Str(_):{
                hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString));
            };
            case lisla.core.Lisla.Arr(array):{
                var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
                var instance = {
                    var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.xml.lixml.LixmlAttributeNameLislaToEntity.process)) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Err(data):{
                            return hxext.ds.Result.Err(data);
                        };
                    };
                    var arg1 = switch (arrayContext.readOptional(lisla.idl.std.lisla2entity.xml.lixml.LixmlAttributeValueLislaToEntity.process, function(data) {
                            return switch data {
                                case lisla.core.Lisla.Str(_):true;
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
                    var instance = new lisla.idl.std.entity.xml.lixml.LixmlAttribute(arg0, arg1);
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
    public static function variableInlineProcess(arrayContext:lisla.idl.lisla2entity.LislaToEntityArrayContext):hxext.ds.Result<lisla.idl.std.entity.xml.lixml.LixmlAttribute, lisla.idl.lisla2entity.error.LislaToEntityError> return null;
}