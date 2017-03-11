package litll.idl.generator.output;

import haxe.macro.Expr.TypeDefinition;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.output.HaxeGenerateConfig;
import litll.idl.generator.output.entity.EntityHaxeGenerator;
import litll.idl.generator.output.litll2entity.LitllToEntityHaxeGenerator;

class HaxeGenerator
{
	public static function run(context:HaxeGenerateConfig):Result<Array<TypeDefinition>, Array<ReadIdlError>>
	{
        var types = [];
		switch EntityHaxeGenerator.generateTypes(context)
        {
            case Result.Ok(generatedTypes):
                for (type in generatedTypes) types.push(type);
                
            case Result.Err(errors):
                return Result.Err(errors);
        }
        
        switch LitllToEntityHaxeGenerator.generateTypes(context)
        {
            case Result.Ok(generatedTypes):
                for (type in generatedTypes) types.push(type);
            
            case Result.Err(errors):
                return Result.Err(errors);
        }
        
        return Result.Ok(types);
	}
}
