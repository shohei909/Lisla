// This file is generated by hxlitll.
package litll.idl.std.delitllfy.idl;
class TypeDefinitionDelitllfier {
    public static function process(context:litll.idl.delitllfy.DelitllfyContext):litll.core.ds.Result<litll.idl.std.data.idl.TypeDefinition, litll.idl.delitllfy.DelitllfyError> return switch context.litll {
        case litll.core.Litll.Arr(data) if (data.length == 3 && data.data[0].match(litll.core.Litll.Str(_.data => "newtype"))):{
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
            var data = {
                arrayContext.readLabel("newtype");
                var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.TypeNameDeclarationDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                var arg1 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.idl.TypeDefinition.Newtype(arg0, arg1));
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
        case litll.core.Litll.Arr(data) if (data.length >= 2 && data.data[0].match(litll.core.Litll.Str(_.data => "tuple"))):{
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
            var data = {
                arrayContext.readLabel("tuple");
                var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.TypeNameDeclarationDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                var arg1 = switch (arrayContext.readRest(litll.idl.std.delitllfy.idl.TupleArgumentDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.idl.TypeDefinition.Tuple(arg0, arg1));
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
        case litll.core.Litll.Arr(data) if (data.length >= 2 && data.data[0].match(litll.core.Litll.Str(_.data => "enum"))):{
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
            var data = {
                arrayContext.readLabel("enum");
                var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.TypeNameDeclarationDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                var arg1 = switch (arrayContext.readRest(litll.idl.std.delitllfy.idl.EnumConstructorDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.idl.TypeDefinition.Enum(arg0, arg1));
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
        case litll.core.Litll.Arr(data) if (data.length >= 2 && data.data[0].match(litll.core.Litll.Str(_.data => "struct"))):{
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
            var data = {
                arrayContext.readLabel("struct");
                var arg0 = switch (arrayContext.read(litll.idl.std.delitllfy.idl.TypeNameDeclarationDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                var arg1 = switch (arrayContext.readRest(litll.idl.std.delitllfy.idl.StructFieldDelitllfier.process)) {
                    case litll.core.ds.Result.Ok(data):{
                        data;
                    };
                    case litll.core.ds.Result.Err(error):{
                        return litll.core.ds.Result.Err(error);
                    };
                };
                litll.core.ds.Result.Ok(litll.idl.std.data.idl.TypeDefinition.Struct(arg0, arg1));
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
        case data:litll.core.ds.Result.Err(litll.idl.delitllfy.DelitllfyError.ofLitll(context.litll, litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor(["newtype", "tuple", "enum", "struct"])));
    };
}