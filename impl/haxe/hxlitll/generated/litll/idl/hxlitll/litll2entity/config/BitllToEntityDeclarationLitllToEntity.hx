// This file is generated by hxlitll.
package litll.idl.hxlitll.litll2entity.config;
class BitllToEntityDeclarationLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.hxlitll.entity.config.BitllToEntityDeclaration, litll.idl.litll2entity.error.LitllToEntityError> return switch context.litll {
        case litll.core.Litll.Arr(array) if (1 <= array.length && array.data[0].match(litll.core.Litll.Str(_.data => "bitll_to_entity"))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = {
                arrayContext.readLabel("bitll_to_entity");
                var arg0 = switch (arrayContext.readFixedInline(litll.idl.hxlitll.litll2entity.config.BitllToEntityConfigLitllToEntity.process, arrayContext.length - 0)) {
                    case hxext.ds.Result.Ok(data):{
                        data;
                    };
                    case hxext.ds.Result.Err(data):{
                        return hxext.ds.Result.Err(data);
                    };
                };
                hxext.ds.Result.Ok(litll.idl.hxlitll.entity.config.BitllToEntityDeclaration.BitllToEntity(arg0));
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
        case litll.core.Litll.Arr(array) if (array.length == 1 && array.data[0].match(litll.core.Litll.Str(_.data => "no_bitll_to_entity"))):{
            var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(array, 0, context.config);
            var data = hxext.ds.Result.Ok(litll.idl.hxlitll.entity.config.BitllToEntityDeclaration.NoBitllToEntity);
            switch (arrayContext.closeOrError()) {
                case haxe.ds.Option.None:{
                    data;
                };
                case haxe.ds.Option.Some(error):{
                    hxext.ds.Result.Err(error);
                };
            };
        };
        case data:hxext.ds.Result.Err(litll.idl.litll2entity.error.LitllToEntityError.ofLitll(context.litll, litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedEnumConstructor(["bitll_to_entity", "no_bitll_to_entity"])));
    };
}