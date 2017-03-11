package lisla.idl.std.tools.idl;
import haxe.macro.Expr.FunctionArg;
import lisla.idl.std.entity.idl.TypeDependenceDeclaration;
import lisla.idl.generator.data.EntityOutputConfig;

class TypeDependenceDeclarationTools 
{
	public static function toHaxeDependences(params:Array<TypeDependenceDeclaration>, config:EntityOutputConfig):Array<FunctionArg>
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