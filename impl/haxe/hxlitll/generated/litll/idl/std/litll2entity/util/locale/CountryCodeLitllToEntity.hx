// This file is generated by hxlitll.
package litll.idl.std.litll2entity.util.locale;
class CountryCodeLitllToEntity {
    public static function process(context:litll.idl.litll2entity.LitllToEntityContext):hxext.ds.Result<litll.idl.std.entity.util.locale.CountryCode, litll.idl.litll2entity.error.LitllToEntityError> {
        return switch (litll.idl.std.litll2entity.StringLitllToEntity.process(context)) {
            case hxext.ds.Result.Ok(data):{
                {
                    var instance = new litll.idl.std.entity.util.locale.CountryCode(data);
                    hxext.ds.Result.Ok(instance);
                };
            };
            case hxext.ds.Result.Err(data):{
                hxext.ds.Result.Err(data);
            };
        };
    }
}