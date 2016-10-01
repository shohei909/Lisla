package litll.idl.std.tools.idl;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.TypeParamDecl;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.haxe.DataOutputConfig;

class TypeParameterDeclarationTools
{
	public static function toHaxeParams(params:Array<TypeParameterDeclaration>):Array<TypeParamDecl> 
	{
		var result:Array<TypeParamDecl>  = [];
		for (param in params)
		{
			switch (param)
			{
				case TypeParameterDeclaration.Dependence(_):
					// nothing to do.
					
				case TypeParameterDeclaration.TypeName(typeName):
					result.push(
						{
							name: typeName.toString(),
						}
					);
			}
		}
		return result;
	}	
	
	public static function toHaxeDependences(params:Array<TypeParameterDeclaration>, config:DataOutputConfig):Array<FunctionArg>
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
					// nothing to do.
			}
		}
		return result;
	}
}
