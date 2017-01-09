package litll.idl.std.tools.idl;
import haxe.macro.Expr.FunctionArg;
import litll.idl.std.data.idl.TypeDependenceDeclaration;
import litll.idl.std.data.idl.haxe.DataOutputConfig;

class TypeDependenceDeclarationTools 
{
	public static function toHaxeDependences(params:Array<TypeDependenceDeclaration>, config:DataOutputConfig):Array<FunctionArg>
	{
		return [
            for (param in params)
            {
                name: param.name.toVariableName(),
                type: ComplexType.TPath(TypeReferenceTools.toMacroTypePath(param.type, config)),
            }
        ];
	}    
}