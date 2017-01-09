package litll.idl.std.tools.idl;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.TypeParam;
import haxe.macro.Expr.TypeParamDecl;
import litll.idl.std.data.idl.TypeName;

class TypeNameTools 
{
	public static function toHaxeParamDecls(typeNames:Array<TypeName>):Array<TypeParamDecl> 
	{
		return [
            for (typeName in typeNames)
            {
                {
                    name: typeName.toString(),
                }
            }
        ];
	}
    
	public static function toHaxeParams(typeNames:Array<TypeName>):Array<TypeParam> 
	{
		return [
            for (typeName in typeNames)
            {
                TypeParam.TPType(
                    ComplexType.TPath(
                        {
                            pack: [],
                            name: typeName.toString(),
                        }
                    )
                );
            }
        ];
	}
}
