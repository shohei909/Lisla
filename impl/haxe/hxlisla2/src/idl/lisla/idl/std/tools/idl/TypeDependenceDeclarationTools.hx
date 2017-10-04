package arraytree.idl.std.tools.idl;
import haxe.macro.Expr.FunctionArg;
import arraytree.idl.std.entity.idl.TypeDependenceDeclaration;
import arraytree.idl.generator.data.EntityOutputConfig;

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