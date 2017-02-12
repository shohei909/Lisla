package litll.idl.std.tools.idl;
import haxe.ds.Option;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.TypeParamDecl;
import litll.core.ds.Maybe;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeDependenceDeclaration;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypePath;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.std.data.idl.TypeReference;

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
	
	public static function toHaxeLitllToBackendArgs(params:Array<TypeParameterDeclaration>, config:DataOutputConfig):Array<FunctionArg>
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
					var haxeTypePath = ComplexType.TPath(new HaxeDataTypePath(new TypePath(Maybe.none(), typeName, typeName.tag)).toMacroPath());
					result.push(
						{
							name: typeName.toLitllToBackendVariableName(),
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
