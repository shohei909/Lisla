package lisla.idl.generator.output;

import haxe.macro.Expr.TypeDefinition;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.output.HaxeGenerateConfig;
import lisla.idl.generator.output.entity.EntityHaxeGenerator;
import lisla.idl.generator.output.lisla2entity.LislaToEntityHaxeGenerator;

class HaxeGenerator
{
	public static function run(context:HaxeGenerateConfig):Result<Array<TypeDefinition>, Array<LoadIdlError>>
	{
        var types = [];
		switch EntityHaxeGenerator.generateTypes(context)
        {
            case Result.Ok(generatedTypes):
                for (type in generatedTypes) types.push(type);
                
            case Result.Err(errors):
                return Result.Err(errors);
        }
        
        switch LislaToEntityHaxeGenerator.generateTypes(context)
        {
            case Result.Ok(generatedTypes):
                for (type in generatedTypes) types.push(type);
            
            case Result.Err(errors):
                return Result.Err(errors);
        }
        
        return Result.Ok(types);
	}
}
