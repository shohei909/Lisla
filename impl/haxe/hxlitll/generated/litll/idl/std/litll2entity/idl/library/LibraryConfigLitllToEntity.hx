// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.idl.library;
class LibraryConfigLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.idl.library.LibraryConfig, lisla.idl.lisla2entity.error.LislaToEntityError> return switch (context.lisla) {
        case lisla.core.Lisla.Str(_):{
            hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString));
        };
        case lisla.core.Lisla.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                var arg1 = haxe.ds.Option.None;
                var arg2 = [];
                var arg3 = [];
                for (lislaData in array.data) {
                    var context = new lisla.idl.lisla2entity.LislaToEntityContext(lislaData, context.config);
                    switch lislaData {
                        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "version")) && array.data[1].match(lisla.core.Lisla.Str(_))):switch (arg0) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(lislaData, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.StructElementDuplicated("version")));
                            };
                            case haxe.ds.Option.None:{
                                arg0 = haxe.ds.Option.Some({
                                    var context = new lisla.idl.lisla2entity.LislaToEntityContext(array.data[1], context.config);
                                    switch (lisla.idl.std.lisla2entity.util.version.VersionLislaToEntity.process(context)) {
                                        case hxext.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case hxext.ds.Result.Err(data):{
                                            return hxext.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "description")) && array.data[1].match(lisla.core.Lisla.Str(_))):switch (arg1) {
                            case haxe.ds.Option.Some(_):{
                                return hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(lislaData, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.StructElementDuplicated("description")));
                            };
                            case haxe.ds.Option.None:{
                                arg1 = haxe.ds.Option.Some({
                                    var context = new lisla.idl.lisla2entity.LislaToEntityContext(array.data[1], context.config);
                                    switch (lisla.idl.std.lisla2entity.StringLislaToEntity.process(context)) {
                                        case hxext.ds.Result.Ok(data):{
                                            data;
                                        };
                                        case hxext.ds.Result.Err(data):{
                                            return hxext.ds.Result.Err(data);
                                        };
                                    };
                                });
                            };
                        };
                        case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "extension")) && array.data[1].match(lisla.core.Lisla.Str(_))):arg2.push(switch (lisla.idl.std.lisla2entity.idl.library.FileExtensionDeclarationLislaToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Err(data):{
                                return hxext.ds.Result.Err(data);
                            };
                        });
                        case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "library"))):arg3.push(switch (lisla.idl.std.lisla2entity.idl.library.LibraryDependenceDeclarationLislaToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Err(data):{
                                return hxext.ds.Result.Err(data);
                            };
                        });
                        case lislaData:return hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(lislaData, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedStructElement(["version", "description", "extension", "library"])));
                    };
                };
                switch (lisla.idl.std.entity.idl.library.LibraryConfig.lislaToEntity(switch (arg0) {
                        case haxe.ds.Option.Some(data):{
                            data;
                        };
                        case haxe.ds.Option.None:{
                            return hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.StructElementNotFound("version")));
                        };
                    }, switch (arg1) {
                        case haxe.ds.Option.Some(data):{
                            data;
                        };
                        case haxe.ds.Option.None:{
                            return hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.StructElementNotFound("description")));
                        };
                    }, arg2, arg3)) {
                    case hxext.ds.Result.Ok(data):{
                        hxext.ds.Result.Ok(data);
                    };
                    case hxext.ds.Result.Err(data):{
                        hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, data));
                    };
                };
            };
        };
    };
}