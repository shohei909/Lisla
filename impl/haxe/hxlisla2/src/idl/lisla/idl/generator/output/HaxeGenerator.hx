package arraytree.idl.generator.output;

import haxe.macro.Expr.TypeDefinition;
import hxext.ds.Result;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.output.HaxeGenerateConfig;
import arraytree.idl.generator.output.entity.EntityHaxeGenerator;
import arraytree.idl.generator.output.arraytree2entity.ArrayTreeToEntityHaxeGenerator;

class HaxeGenerator
{
	public static function run(context:HaxeGenerateConfig):Result<Array<TypeDefinition>, Array<LoadIdlError>>
	{
        var types = [];
		switch EntityHaxeGenerator.generateTypes(context)
        {
            case Result.Ok(generatedTypes):
                for (type in generatedTypes) types.push(type);
                
            case Result.Error(errors):
                return Result.Error(errors);
        }
        
        switch ArrayTreeToEntityHaxeGenerator.generateTypes(context)
        {
            case Result.Ok(generatedTypes):
                for (type in generatedTypes) types.push(type);
            
            case Result.Error(errors):
                return Result.Error(errors);
        }
        
        return Result.Ok(types);
	}
}
