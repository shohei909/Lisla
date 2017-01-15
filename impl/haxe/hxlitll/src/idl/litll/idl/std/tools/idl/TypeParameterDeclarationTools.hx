package litll.idl.std.tools.idl;
import haxe.ds.Option;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.TypeParamDecl;
import litll.core.ds.Maybe;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.std.data.idl.TypeDependenceDeclaration;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.haxe.DataOutputConfig;

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
				
				case TypeParameterDeclaration.Dependence(name, type):
					dependences.push(new TypeDependenceDeclaration(name, type));
			}
		}
        
        return {
            parameters: parameters,
            dependences: dependences,
        }
    }
	
	public static function toHaxeDelitllfierArgs(params:Array<TypeParameterDeclaration>, config:DataOutputConfig):Array<FunctionArg>
	{
		var result:Array<FunctionArg>  = [];
		for (param in params)
		{
			switch (param)
			{
				case TypeParameterDeclaration.Dependence(name, type):
					result.push(
						{
							name: name.toVariableName(),
							type: ComplexType.TPath(TypeReferenceTools.toMacroTypePath(type, config)),
						}
					);
					
				case TypeParameterDeclaration.TypeName(typeName):
					var haxeTypePath = ComplexType.TPath(new HaxeDataTypePath(new TypePath(Maybe.none(), typeName, typeName.tag)).toMacroPath());
					result.push(
						{
							name: typeName.toProcessFunctionName(),
							type: macro:litll.idl.delitllfy.DelitllfyContext->litll.core.ds.Result<$haxeTypePath, litll.idl.delitllfy.DelitllfyError>,
						}
					);
			}
		}
		return result;
	}
}
