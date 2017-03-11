// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.idl;
class TypeDefinitionLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.idl.TypeDefinition, lisla.idl.lisla2entity.error.LislaToEntityError> return switch context.lisla {
        case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "newtype"))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("newtype");
                var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.idl.TypeNameDeclarationLislaToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                var arg1 = switch (arrayContext.read(lisla.idl.std.lisla2entity.idl.TypeReferenceLislaToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(lisla.idl.std.entity.idl.TypeDefinition.Newtype(arg0, arg1));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Err(error);
                };
            };
        };
        case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "tuple"))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("tuple");
                var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.idl.TypeNameDeclarationLislaToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                var arg1 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.idl.TupleElementLislaToEntity.process, function(data) {
                        return switch data {
                            case lisla.core.Lisla.Str(_):true;
                            case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.length <= 3 && array.data[0].match(lisla.core.Lisla.Str(_))):true;
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
                hxext.ds.Result.Ok(lisla.idl.std.entity.idl.TypeDefinition.Tuple(arg0, arg1));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Err(error);
                };
            };
        };
        case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "enum"))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("enum");
                var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.idl.TypeNameDeclarationLislaToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                var arg1 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.idl.EnumConstructorLislaToEntity.process, function(data) {
                        return switch data {
                            case lisla.core.Lisla.Str(_):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_))):true;
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
                hxext.ds.Result.Ok(lisla.idl.std.entity.idl.TypeDefinition.Enum(arg0, arg1));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Err(error);
                };
            };
        };
        case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "struct"))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("struct");
                var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.idl.TypeNameDeclarationLislaToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                var arg1 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.idl.StructElementLislaToEntity.process, function(data) {
                        return switch data {
                            case lisla.core.Lisla.Str(_):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 1 && array.data[0].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.length <= 3 && array.data[0].match(lisla.core.Lisla.Str(_))):true;
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
                hxext.ds.Result.Ok(lisla.idl.std.entity.idl.TypeDefinition.Struct(arg0, arg1));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Err(error);
                };
            };
        };
        case data:hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedEnumConstructor(["newtype", "tuple", "enum", "struct"])));
    };
}