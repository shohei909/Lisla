package litll.idl.generator.output.entity;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.output.EntityTypeInfomation;
import litll.idl.generator.output.IdlToHaxeGenerateContext;
import haxe.macro.Expr.TypeDefinition;

class EntityHaxeGenerator 
{
    public static function generateTypes(context:IdlToHaxeGenerateContext):Result<Array<TypeDefinition>, Array<ReadIdlError>>
    {
        return switch context.resolveTargets()
		{
			case Result.Ok(data):
                var config = context.entityOutputConfig;
                
                Result.Ok(
                    [
                        for (info in data.infomations)
                        {
                            if (config.predefinedTypes.exists(info.haxePath.toString()))
                            {
                                continue;
                            }
                            EntityHaxeTypeBuilder.convertType(info, config);
                        }
                    ]
                );
                
			case Result.Err(errors):
                Result.Err(errors);
		}
    }
}
