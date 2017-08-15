package lisla.idl.std.tools.idl;
import haxe.ds.Option;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.TypeParamDecl;
import hxext.ds.Maybe;
import lisla.idl.generator.output.entity.EntityHaxeTypePath;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.idl.std.entity.idl.TypeDependenceDeclaration;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypeParameterDeclaration;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.generator.data.EntityOutputConfig;
import lisla.idl.std.entity.idl.TypeReference;

class TypeParameterDeclarationTools
{
    public static function collect(params:Array<TypeParameterDeclaration>):TypeParameterDeclarationCollection
    {
        var parameters = [];
        var dependences = [];
        
        for (typeParameter in params)
		{
			switch (typeParameter)
			{
				case TypeParameterDeclaration.TypeName(typeName):
                    parameters.push(typeName);
				
				case TypeParameterDeclaration.Dependence(declaration):
					dependences.push(declaration);
			}
		}
        
        return {
            parameters: parameters,
            dependences: dependences,
        }
    }
	
	public static function toHaxeLislaToEntityArgs(params:Array<TypeParameterDeclaration>, config:EntityOutputConfig):Array<FunctionArg>
	{
		var result:Array<FunctionArg>  = [];
		for (param in params)
		{
			switch (param)
			{
				case TypeParameterDeclaration.Dependence(dependence):
					result.push(
						{
							name: dependence.name.toVariableName(),
							type: ComplexType.TPath(TypeReferenceTools.toMacroTypePath(dependence.type, config)),
						}
					);
					
				case TypeParameterDeclaration.TypeName(typeName):
					var haxeTypePath = ComplexType.TPath(new EntityHaxeTypePath(new TypePath(Maybe.none(), typeName, typeName.metadata)).toMacroPath());
					result.push(
						{
							name: typeName.toLislaToEntityVariableName(),
                            type: null
						}
					);
			}
		}
		return result;
	}
    
    public static function iterateOverTypeReference(params:Array<TypeParameterDeclaration>, func:TypeReference-> Void) 
    {
        for (param in params)
		{
			switch (param)
			{
				case TypeParameterDeclaration.Dependence(dependence):
					func(dependence.type);
					
				case TypeParameterDeclaration.TypeName(typeName):
					// nothing to do
			}
		}
    }
}
