// This file is generated by hxlitll.
package litll.idl.std.litll2entity.ir;
class PrimitiveIrLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.data.ir.PrimitiveIr, litll.idl.litll2entity.error.LitllToEntityError> return switch context.litll {
        case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_int")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("fixed_int");
                var arg0 = switch (arrayContext.read(litll.idl.std.litll2entity.core.UInt64LitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                var arg1 = switch (arrayContext.read(litll.idl.std.litll2entity.core.BigIntLitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.ir.PrimitiveIr.FixedInt(arg0, arg1));
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
        case litll.core.Litll.Arr(array) if (array.length == 3 && array.data[0].match(litll.core.Litll.Str(_.data => "fixed_uint")) && array.data[1].match(litll.core.Litll.Str(_)) && array.data[2].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("fixed_uint");
                var arg0 = switch (arrayContext.read(litll.idl.std.litll2entity.core.UInt64LitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                var arg1 = switch (arrayContext.read(litll.idl.std.litll2entity.core.BigUIntLitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.ir.PrimitiveIr.FixedUint(arg0, arg1));
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
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_int")) && array.data[1].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("variable_int");
                var arg0 = switch (arrayContext.read(litll.idl.std.litll2entity.core.BigIntLitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.ir.PrimitiveIr.VariableInt(arg0));
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
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "variable_uint")) && array.data[1].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("variable_uint");
                var arg0 = switch (arrayContext.read(litll.idl.std.litll2entity.core.BigUIntLitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.ir.PrimitiveIr.VariableUint(arg0));
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
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "float64")) && array.data[1].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("float64");
                var arg0 = switch (arrayContext.read(litll.idl.std.litll2entity.core.Float64LitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.ir.PrimitiveIr.Float64(arg0));
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
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "boolean")) && array.data[1].match(litll.core.Litll.Str(_.data => "true")) && array.data[1].match(litll.core.Litll.Str(_.data => "false"))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("boolean");
                var arg0 = switch (arrayContext.read(litll.idl.std.litll2entity.core.BooleanLitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.ir.PrimitiveIr.Boolean(arg0));
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
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "string")) && array.data[1].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("string");
                var arg0 = switch (arrayContext.read(StringLitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.ir.PrimitiveIr.String(arg0));
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
        case litll.core.Litll.Arr(array) if (array.length == 2 && array.data[0].match(litll.core.Litll.Str(_.data => "binary")) && array.data[1].match(litll.core.Litll.Str(_))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("binary");
                var arg0 = switch (arrayContext.read(litll.idl.std.litll2entity.core.BinaryLitllToEntity.process)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.std.data.ir.PrimitiveIr.Binary(arg0));
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
        case data:hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedEnumConstructor(["fixed_int", "fixed_uint", "variable_int", "variable_uint", "float64", "boolean", "string", "binary"])));
    };
    public static function fixedInlineProcess(context:litll.idl.litll2entity.LitllToEntityArrayContext):hxext.ds.Result<litll.idl.std.data.ir.PrimitiveIr, litll.idl.litll2entity.error.LitllToEntityError> return null;
}