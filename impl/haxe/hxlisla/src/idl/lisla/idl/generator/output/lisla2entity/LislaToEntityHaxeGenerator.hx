package lisla.idl.generator.output.lisla2entity;
import haxe.macro.Expr.TypeDefinition;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.output.HaxeConvertContext;
import lisla.idl.generator.output.lisla2entity.build.LislaToEntityHaxeTypeBuilder;
import lisla.idl.generator.output.lisla2entity.path.HaxeLislaToEntityTypePathPair;
using hxext.ds.ResultTools;

class LislaToEntityHaxeGenerator
{
	public static function generateTypes(context:HaxeGenerateConfig):Result<Array<TypeDefinition>, Array<LoadIdlError>>
	{
        return switch (context.resolveTargets())
		{
			case Result.Ok(data):
                var config = context.lislaToEntityOutputConfig;
                
                var convertContext = new HaxeConvertContext(
                    data.library, 
                    context.entityOutputConfig,
                    config
                );
                
                var types = [];
                if (!config.noOutput)
                {
                    for (info in data.infomations)
                    {
                        
                        var pathPair = new HaxeLislaToEntityTypePathPair(
                            info,
                            config.toHaxeLislaToEntityPath(info.typePath)
                        );
                        
                        types.push(LislaToEntityHaxeTypeBuilder.convertType(pathPair, convertContext));
                    }
                }
                Result.Ok(types);
                
			case Result.Err(errors):
                Result.Err(errors);
		}
	}
}
