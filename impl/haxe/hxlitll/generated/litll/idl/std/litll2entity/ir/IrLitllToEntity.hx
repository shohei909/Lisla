// This file is generated by hxlisla.
package lisla.idl.std.lisla2entity.ir;
class IrLislaToEntity {
    public static function process(context:lisla.idl.lisla2entity.LislaToEntityContext):hxext.ds.Result<lisla.idl.std.entity.ir.Ir, lisla.idl.lisla2entity.error.LislaToEntityError> return switch context.lisla {
        case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "array"))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("array");
                var arg0 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.ir.IrLislaToEntity.process, function(data) {
                        return switch data {
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "array"))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "option")) && array.data[1].match(lisla.core.Lisla.Arr(_))):true;
                            case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "enum")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "tuple"))):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "struct"))):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "map"))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "fixed_int")) && array.data[1].match(lisla.core.Lisla.Str(_)) && array.data[2].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "fixed_uint")) && array.data[1].match(lisla.core.Lisla.Str(_)) && array.data[2].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "variable_int")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "variable_uint")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "float64")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "boolean")) && array.data[1].match(lisla.core.Lisla.Str(_.data => "true")) && array.data[1].match(lisla.core.Lisla.Str(_.data => "false"))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "string")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "binary")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
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
                hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Array(arg0));
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
        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "option")) && array.data[1].match(lisla.core.Lisla.Arr(_))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("option");
                var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.core.OptionLislaToEntity.process.bind(_, lisla.idl.std.lisla2entity.ir.IrLislaToEntity))) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Option(arg0));
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
        case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "enum")) && array.data[1].match(lisla.core.Lisla.Str(_))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("enum");
                var arg0 = switch (arrayContext.read(lisla.idl.std.lisla2entity.StringLislaToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                var arg1 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.ir.IrLislaToEntity.process, function(data) {
                        return switch data {
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "array"))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "option")) && array.data[1].match(lisla.core.Lisla.Arr(_))):true;
                            case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "enum")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "tuple"))):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "struct"))):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "map"))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "fixed_int")) && array.data[1].match(lisla.core.Lisla.Str(_)) && array.data[2].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "fixed_uint")) && array.data[1].match(lisla.core.Lisla.Str(_)) && array.data[2].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "variable_int")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "variable_uint")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "float64")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "boolean")) && array.data[1].match(lisla.core.Lisla.Str(_.data => "true")) && array.data[1].match(lisla.core.Lisla.Str(_.data => "false"))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "string")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "binary")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
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
                hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Enum(arg0, arg1));
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
        case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "tuple"))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("tuple");
                var arg0 = switch (arrayContext.readRest(lisla.idl.std.lisla2entity.ir.IrLislaToEntity.process, function(data) {
                        return switch data {
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "array"))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "option")) && array.data[1].match(lisla.core.Lisla.Arr(_))):true;
                            case lisla.core.Lisla.Arr(array) if (2 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "enum")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "tuple"))):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "struct"))):true;
                            case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "map"))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "fixed_int")) && array.data[1].match(lisla.core.Lisla.Str(_)) && array.data[2].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "fixed_uint")) && array.data[1].match(lisla.core.Lisla.Str(_)) && array.data[2].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "variable_int")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "variable_uint")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "float64")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "boolean")) && array.data[1].match(lisla.core.Lisla.Str(_.data => "true")) && array.data[1].match(lisla.core.Lisla.Str(_.data => "false"))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "string")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
                            case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "binary")) && array.data[1].match(lisla.core.Lisla.Str(_))):true;
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
                hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Tuple(arg0));
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
        case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "struct"))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("struct");
                var arg0 = switch (arrayContext.readFixedInline(lisla.idl.std.lisla2entity.core.MapLislaToEntity.process.bind(_, lisla.idl.std.lisla2entity.StringLislaToEntity, lisla.idl.std.lisla2entity.ir.IrLislaToEntity), arrayContext.length - 0)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Struct(arg0));
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
        case lisla.core.Lisla.Arr(array) if (1 <= array.length && array.data[0].match(lisla.core.Lisla.Str(_.data => "map"))):{
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("map");
                var arg0 = switch (arrayContext.readFixedInline(lisla.idl.std.lisla2entity.core.MapLislaToEntity.process.bind(_, lisla.idl.std.lisla2entity.ir.PrimitiveIrLislaToEntity, lisla.idl.std.lisla2entity.ir.IrLislaToEntity), arrayContext.length - 0)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Map(arg0));
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
        case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "fixed_int")) && array.data[1].match(lisla.core.Lisla.Str(_)) && array.data[2].match(lisla.core.Lisla.Str(_))):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Primitive(switch (lisla.idl.std.lisla2entity.ir.PrimitiveIrLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case lisla.core.Lisla.Arr(array) if (array.length == 3 && array.data[0].match(lisla.core.Lisla.Str(_.data => "fixed_uint")) && array.data[1].match(lisla.core.Lisla.Str(_)) && array.data[2].match(lisla.core.Lisla.Str(_))):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Primitive(switch (lisla.idl.std.lisla2entity.ir.PrimitiveIrLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "variable_int")) && array.data[1].match(lisla.core.Lisla.Str(_))):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Primitive(switch (lisla.idl.std.lisla2entity.ir.PrimitiveIrLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "variable_uint")) && array.data[1].match(lisla.core.Lisla.Str(_))):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Primitive(switch (lisla.idl.std.lisla2entity.ir.PrimitiveIrLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "float64")) && array.data[1].match(lisla.core.Lisla.Str(_))):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Primitive(switch (lisla.idl.std.lisla2entity.ir.PrimitiveIrLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "boolean")) && array.data[1].match(lisla.core.Lisla.Str(_.data => "true")) && array.data[1].match(lisla.core.Lisla.Str(_.data => "false"))):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Primitive(switch (lisla.idl.std.lisla2entity.ir.PrimitiveIrLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "string")) && array.data[1].match(lisla.core.Lisla.Str(_))):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Primitive(switch (lisla.idl.std.lisla2entity.ir.PrimitiveIrLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case lisla.core.Lisla.Arr(array) if (array.length == 2 && array.data[0].match(lisla.core.Lisla.Str(_.data => "binary")) && array.data[1].match(lisla.core.Lisla.Str(_))):{
            hxext.ds.Result.Ok(lisla.idl.std.entity.ir.Ir.Primitive(switch (lisla.idl.std.lisla2entity.ir.PrimitiveIrLislaToEntity.process(context)) {
                case hxext.ds.Result.Ok(data):{
                    data;
                };
                case hxext.ds.Result.Err(data):{
                    return hxext.ds.Result.Err(data);
                };
            }));
        };
        case data:hxext.ds.Result.Err(lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(context.lisla, lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedEnumConstructor(["array", "option", "enum", "tuple", "struct", "map"])));
    };
}