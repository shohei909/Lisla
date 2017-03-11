package litll.idl.generator.output.litll2entity;
import haxe.macro.Expr.TypeDefinition;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.output.IdlToHaxeConvertContext;
import litll.idl.generator.output.litll2entity.build.LitllToEntityHaxeTypeBuilder;
import litll.idl.generator.output.litll2entity.path.HaxeLitllToEntityTypePathPair;
using hxext.ds.ResultTools;

class LitllToEntityHaxeGenerator
{
	public static function generateTypes(context:IdlToHaxeGenerateContext):Result<Array<TypeDefinition>, Array<ReadIdlError>>
	{
        return switch (context.resolveTargets())
		{
			case Result.Ok(data):
                var config = context.litllToEntityOutputConfig;
                
                var convertContext = new IdlToHaxeConvertContext(
                    data.library, 
                    context.entityOutputConfig,
                    config
                );
                
                Result.Ok(
                    [
                        for (info in data.infomations)
                        {
                            var pathPair = new HaxeLitllToEntityTypePathPair(
                                info,
                                config.toHaxeLitllToEntityPath(info.typePath)
                            );
                            
                            LitllToEntityHaxeTypeBuilder.convertType(pathPair, convertContext);
                        }
                    ]
                );
                
			case Result.Err(errors):
                Result.Err(errors);
		}
	}
}
