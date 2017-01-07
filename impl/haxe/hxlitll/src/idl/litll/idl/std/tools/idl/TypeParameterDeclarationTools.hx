package litll.idl.std.tools.idl;
import haxe.ds.Option;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.TypeParamDecl;
import litll.core.ds.Maybe;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypePath;
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
	
	public static function toHaxeDelitllfierArgs(params:Array<TypeParameterDeclaration>, config:DataOutputConfig):Array<FunctionArg>
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
							name: typeName.toVariableName() + "Process",
							type: macro:litll.idl.delitllfy.DelitllfyContext->$haxeTypePath,
						}
					);
			}
		}
		return result;
	}
}
