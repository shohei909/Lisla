package lisla.idl.generator.output.entity;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.output.EntityTypeInfomation;
import lisla.idl.generator.output.HaxeGenerateConfig;
import haxe.macro.Expr.TypeDefinition;

class EntityHaxeGenerator 
{
    public static function generateTypes(context:HaxeGenerateConfig):Result<Array<TypeDefinition>, Array<LoadIdlError>>
    {
        return switch context.resolveTargets()
		{
			case Result.Ok(data):
                var config = context.entityOutputConfig;
                var types = [];
                if (!config.noOutput)
                {
                    for (info in data.infomations)
                    {
                        if (config.predefinedTypes.exists(info.haxePath.toString()))
                        {
                            continue;
                        }
                        
                        types.push(EntityHaxeTypeBuilder.convertType(info, config));
                    }
                }
                Result.Ok(types);
                
			case Result.Error(errors):
                Result.Error(errors);
		}
    }
}
