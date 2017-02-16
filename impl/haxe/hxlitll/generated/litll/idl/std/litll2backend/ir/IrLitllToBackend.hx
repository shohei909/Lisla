// This file is generated by hxlitll.
package litll.idl.std.litll2backend.ir;
class IrLitllToBackend {
    public static function process(context:litll.idl.litll2backend.LitllToBackendContext):litll.core.ds.Result<litll.idl.std.data.ir.Ir, litll.idl.litll2backend.LitllToBackendError> return switch context.litll {
        case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "array"))):{
            var arrayContext = new litll.idl.litll2backend.LitllToBackendArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("array");
                var arg0 = switch (arrayContext.readRest(litll.idl.std.litll2backend.ir.IrLitllToBackend.process, function(data) {
                        return switch data {
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "array"))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "option")) && array.data[1].match(litll.core.Litll.Arr(_))):true;
                            case litll.core.Litll.Arr(array) if (2 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "enum")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "tuple"))):true;
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "struct"))):true;
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "map"))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_int")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_uint")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_int")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_uint")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "float64")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "boolean")) && array.data[1].match(litll.core.Litll.Str(_.data => "true")) && array.data[1].match(litll.core.Litll.Str(_.data => "false"))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "string")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "binary")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case _:false;
                        };
                    })) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(data):{
                        return litll.core.ds.Result.Err(data);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Array(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    litll.core.ds.Result.Err(error);
                };
            };
        };
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "option")) && array.data[1].match(litll.core.Litll.Arr(_))):{
            var arrayContext = new litll.idl.litll2backend.LitllToBackendArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("option");
                var arg0 = switch (arrayContext.read(litll.idl.std.litll2backend.core.OptionLitllToBackend.process.bind(_, litll.idl.std.litll2backend.ir.IrLitllToBackend))) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(data):{
                        return litll.core.ds.Result.Err(data);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Option(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    litll.core.ds.Result.Err(error);
                };
            };
        };
        case litll.core.Litll.Arr(array) if (2 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "enum")) && array.data[1].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.litll2backend.LitllToBackendArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("enum");
                var arg0 = switch (arrayContext.read(StringLitllToBackend.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(data):{
                        return litll.core.ds.Result.Err(data);
                    };
                };
                var arg1 = switch (arrayContext.readRest(litll.idl.std.litll2backend.ir.IrLitllToBackend.process, function(data) {
                        return switch data {
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "array"))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "option")) && array.data[1].match(litll.core.Litll.Arr(_))):true;
                            case litll.core.Litll.Arr(array) if (2 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "enum")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "tuple"))):true;
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "struct"))):true;
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "map"))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_int")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_uint")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_int")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_uint")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "float64")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "boolean")) && array.data[1].match(litll.core.Litll.Str(_.data => "true")) && array.data[1].match(litll.core.Litll.Str(_.data => "false"))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "string")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "binary")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case _:false;
                        };
                    })) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(data):{
                        return litll.core.ds.Result.Err(data);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Enum(arg0, arg1));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    litll.core.ds.Result.Err(error);
                };
            };
        };
        case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "tuple"))):{
            var arrayContext = new litll.idl.litll2backend.LitllToBackendArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("tuple");
                var arg0 = switch (arrayContext.readRest(litll.idl.std.litll2backend.ir.IrLitllToBackend.process, function(data) {
                        return switch data {
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "array"))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "option")) && array.data[1].match(litll.core.Litll.Arr(_))):true;
                            case litll.core.Litll.Arr(array) if (2 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "enum")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "tuple"))):true;
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "struct"))):true;
                            case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "map"))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_int")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_uint")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_int")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_uint")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "float64")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "boolean")) && array.data[1].match(litll.core.Litll.Str(_.data => "true")) && array.data[1].match(litll.core.Litll.Str(_.data => "false"))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "string")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "binary")) && array.data[1].match(litll.core.Litll.Str(_))):true;
                            case _:false;
                        };
                    })) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(data):{
                        return litll.core.ds.Result.Err(data);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Tuple(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    litll.core.ds.Result.Err(error);
                };
            };
        };
        case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "struct"))):{
            var arrayContext = new litll.idl.litll2backend.LitllToBackendArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("struct");
                var arg0 = switch (arrayContext.readFixedInline(litll.idl.std.litll2backend.core.MapLitllToBackend.fixedInlineProcess.bind(_, StringLitllToBackend, litll.idl.std.litll2backend.ir.IrLitllToBackend), arrayContext.length - 0)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(data):{
                        return litll.core.ds.Result.Err(data);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Struct(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    litll.core.ds.Result.Err(error);
                };
            };
        };
        case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "map"))):{
            var arrayContext = new litll.idl.litll2backend.LitllToBackendArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("map");
                var arg0 = switch (arrayContext.readFixedInline(litll.idl.std.litll2backend.core.MapLitllToBackend.fixedInlineProcess.bind(_, litll.idl.std.litll2backend.ir.PrimitiveIrLitllToBackend, litll.idl.std.litll2backend.ir.IrLitllToBackend), arrayContext.length - 0)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(data):{
                        return litll.core.ds.Result.Err(data);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Map(arg0));
            };
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    litll.core.ds.Result.Err(error);
                };
            };
        };
        case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_int")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Primitive(switch (litll.idl.std.litll2backend.ir.PrimitiveIrLitllToBackend.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_uint")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Primitive(switch (litll.idl.std.litll2backend.ir.PrimitiveIrLitllToBackend.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_int")) && array.data[1].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Primitive(switch (litll.idl.std.litll2backend.ir.PrimitiveIrLitllToBackend.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_uint")) && array.data[1].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Primitive(switch (litll.idl.std.litll2backend.ir.PrimitiveIrLitllToBackend.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "float64")) && array.data[1].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Primitive(switch (litll.idl.std.litll2backend.ir.PrimitiveIrLitllToBackend.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "boolean")) && array.data[1].match(litll.core.Litll.Str(_.data => "true")) && array.data[1].match(litll.core.Litll.Str(_.data => "false"))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Primitive(switch (litll.idl.std.litll2backend.ir.PrimitiveIrLitllToBackend.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "string")) && array.data[1].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Primitive(switch (litll.idl.std.litll2backend.ir.PrimitiveIrLitllToBackend.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "binary")) && array.data[1].match(litll.core.Litll.Str(_))):{
            litll.core.ds.Result.Ok(litll.idl.std.data.ir.Ir.Primitive(switch (litll.idl.std.litll2backend.ir.PrimitiveIrLitllToBackend.process(context)) {
                case litll.core.ds.Result.Ok(data):{
                    data;
                };
                case litll.core.ds.Result.Err(data):{
                    return litll.core.ds.Result.Err(data);
                };
            }));
        };
        case data:litll.core.ds.Result.Err(litll.idl.litll2backend.LitllToBackendError.ofLitll(context.litll, litll.idl.litll2backend.LitllToBackendErrorKind.UnmatchedEnumConstructor(["array", "option", "enum", "tuple", "struct", "map"])));
    };
}