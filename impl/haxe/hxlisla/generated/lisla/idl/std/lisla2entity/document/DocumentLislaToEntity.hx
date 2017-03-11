// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.document;
class DocumentLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.document.Document, lisla.idl.lisla2entity.error.LislaToEntityError> return switch (context.lisla) {
        case lisla.core.Lisla.Str(_):{
            hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString));
        };
        case lisla.core.Lisla.Arr(array):{
            {
                var arg0 = [];
                for (lislaData in array.data) {
                    var context = new lisla.idl.lisla2entity.LislaToEntityContext(lislaData, context.config);
                    switch lislaData {
                        case lisla.core.Lisla.Str(_):arg0.push(switch (lisla.idl.std.lisla2entity.StringLislaToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Err(data):{
                                return hxext.ds.Result.Err(data);
                            };
                        });
                        case lislaData:return hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(lislaData, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedStructElement(["comment"])));
                    };
                };
                var instance = new lisla.idl.std.entity.document.Document(arg0);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
    public static function variableInlineProcess(arrayContext:lisla.idl.lisla2entity.LislaToEntityArrayContext):hxext.ds.Result<lisla.idl.std.entity.document.Document, lisla.idl.lisla2entity.error.LislaToEntityError> return null;
}