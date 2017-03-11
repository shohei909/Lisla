// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.cli.clidl;
class NameConfigLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.cli.clidl.NameConfig, lisla.idl.lisla2entity.error.LislaToEntityError> return switch (context.lisla) {
        case lisla.core.Lisla.Str(_):{
            hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString));
        };
        case lisla.core.Lisla.Arr(array):{
            {
                var arg0 = [];
                var arg1 = [];
                for (lislaData in array.data) {
                    var context = new lisla.idl.lisla2entity.LislaToEntityContext(lislaData, context.config);
                    switch lislaData {
                        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "short")) && array.data[1].match(lisla.core.Lisla.Str(_))):arg0.push({
                            var context = new lisla.idl.lisla2entity.LislaToEntityContext(array.data[1], context.config);
                            switch (lisla.idl.std.lisla2entity.cli.clidl.CommandNameLislaToEntity.process(context)) {
                                case hxext.ds.Result.Ok(data):{
                                    data;
                                };
                                case hxext.ds.Result.Err(data):{
                                    return hxext.ds.Result.Err(data);
                                };
                            };
                        });
                        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "long")) && array.data[1].match(lisla.core.Lisla.Str(_))):arg1.push({
                            var context = new lisla.idl.lisla2entity.LislaToEntityContext(array.data[1], context.config);
                            switch (lisla.idl.std.lisla2entity.cli.clidl.CommandNameLislaToEntity.process(context)) {
                                case hxext.ds.Result.Ok(data):{
                                    data;
                                };
                                case hxext.ds.Result.Err(data):{
                                    return hxext.ds.Result.Err(data);
                                };
                            };
                        });
                        case lislaData:return hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(lislaData, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedStructElement(["short", "long"])));
                    };
                };
                var instance = new lisla.idl.std.entity.cli.clidl.NameConfig(arg0, arg1);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
}