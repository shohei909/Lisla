package arraytree.idl.generator.output.arraytree2entity;
import haxe.macro.Expr.TypeDefinition;
import hxext.ds.Result;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.output.HaxeConvertContext;
import arraytree.idl.generator.output.arraytree2entity.build.ArrayTreeToEntityHaxeTypeBuilder;
import arraytree.idl.generator.output.arraytree2entity.path.HaxeArrayTreeToEntityTypePathPair;
using hxext.ds.ResultTools;

class ArrayTreeToEntityHaxeGenerator
{
	public static function generateTypes(context:HaxeGenerateConfig):Result<Array<TypeDefinition>, Array<LoadIdlError>>
	{
        return switch (context.resolveTargets())
		{
			case Result.Ok(data):
                var config = context.arraytreeToEntityOutputConfig;
                
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
                        
                        var pathPair = new HaxeArrayTreeToEntityTypePathPair(
                            info,
                            config.toHaxeArrayTreeToEntityPath(info.typePath)
                        );
                        
                        types.push(ArrayTreeToEntityHaxeTypeBuilder.convertType(pathPair, convertContext));
                    }
                }
                Result.Ok(types);
                
			case Result.Error(errors):
                Result.Error(errors);
		}
	}
}
