package litll.idl.generator.data;
import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.Type.BaseType;
import hxext.ds.Maybe;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.idl.generator.output.entity.EntityHaxeTypePath;
import litll.idl.generator.output.entity.store.HaxeEntityClassInterface;
import litll.idl.generator.output.entity.store.HaxeEntityConstructorKind;
import litll.idl.generator.output.entity.store.HaxeEntityConstructorReturnKind;
import litll.idl.generator.output.entity.store.HaxeEntityEnumInterface;
import litll.idl.generator.output.entity.store.HaxeEntityInterface;
import litll.idl.generator.output.entity.store.HaxeEntityInterfaceKind;
import litll.idl.std.entity.idl.ArgumentName;
import litll.idl.std.entity.idl.EnumConstructorName;
import litll.idl.std.entity.idl.ModulePath;
import litll.idl.std.entity.idl.PackagePath;
import litll.idl.std.entity.idl.StructElementName;
import litll.idl.std.entity.idl.TypeDependenceName;
import litll.idl.std.entity.idl.TypeName;
import litll.idl.std.entity.idl.TypePath;
import litll.idl.std.entity.idl.TypeReferenceParameter;
import litll.idl.std.entity.idl.group.TypeGroupFilter;
import litll.idl.std.entity.idl.group.TypeGroupPath;
import litll.idl.std.entity.idl.library.LibraryConfig;
import litll.idl.std.tools.idl.group.TypeGroupFilterTools;
using hxext.ds.ResultTools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;

class EntityOutputConfig
{
	public var filters(default, null):Array<TypeGroupFilter>;
	public var predefinedTypes(default, null):Map<String, HaxeEntityInterface>;
	
	#if !macro
	public function new(filters:Array<TypeGroupFilter>) 
	{
		this.filters = filters.concat(
            [
                TypeGroupFilterTools.create("Array",          "litll.core.LitllArray"),
                TypeGroupFilterTools.create("String",         "litll.core.LitllString"),
                TypeGroupFilterTools.create("litll.core.Any", "litll.core.Litll"),
            ]
        );
		
		predefinedTypes = new Map();
		
		this.addPredefinedType(Litll);
		this.addPredefinedType(LitllArray);
		this.addPredefinedType(LitllString);
		this.addPredefinedType(ArgumentName);
		this.addPredefinedType(EnumConstructorName);
		this.addPredefinedType(ModulePath);
		this.addPredefinedType(PackagePath);
		this.addPredefinedType(TypeName);
		this.addPredefinedType(TypePath);
		this.addPredefinedType(TypeDependenceName);
		this.addPredefinedType(TypeReferenceParameter);
		this.addPredefinedType(StructElementName);
		this.addPredefinedType(TypeGroupPath);
		this.addPredefinedType(TypeGroupFilter);
        this.addPredefinedType(LibraryConfig);
	}
	#end
	
	public function toHaxePath(typePath:TypePath):EntityHaxeTypePath
	{
        var l = filters.length;
        
		for (i in 0...l)
		{
			var filter = filters[l - i - 1];
			switch (filter.apply(typePath).toOption())
			{
				case Option.Some(convertedPath):
                    typePath = convertedPath;
					break;
                    
				case Option.None:
			}
		}
		
		return new EntityHaxeTypePath(typePath);
	}
	
	public function addPredefinedTypeDirectly(path:String, data:litll.idl.generator.output.entity.store.HaxeEntityInterface):Void
	{
		predefinedTypes[path] = data;
	}
	
	public macro function addPredefinedType(_this:Expr, expr:Expr):Expr
	{
		var type = Context.getType(ExprTools.toString(expr));
		
		var baseType:BaseType;
		var data:Expr = switch (type)
		{
			case TInst(ref, params):
				var classType = ref.get();
				baseType = classType;
				addPredefinedClass(type, classType, params);
				
			case TAbstract(ref, params):
				var classType = ref.get().impl.get();
				baseType = ref.get();
				addPredefinedClass(type, classType, params);
		
			case TEnum(ref, params):
				baseType = ref.get();
				macro HaxeEntityInterfaceKind.Enum(
					new HaxeEntityEnumInterface()
				);
						
			case _: 
				throw "unsupported type " + type;
		}
		
		var typePathString:String = baseType.pack.concat([baseType.name]).join(".");
		return macro $_this.addPredefinedTypeDirectly(
			$v{typePathString}, 
			new HaxeEntityInterface(
				new EntityHaxeTypePath(
					new TypePath(
						Maybe.some(new ModulePath($v{baseType.pack})), 
						new TypeName(new LitllString($v{baseType.name}))
					)
				),
				$data
			)
		);
	}
	
	
	#if macro
	private static function addPredefinedClass(type:Type, ref:ClassType, params:Array<Type>):Expr
	{
		var fields = ref.statics.get();
		var createFunc = Maybe.none();
		for (field in fields)
		{
			if (field.meta.has(":litllToEntity"))
			{
				createFunc = Maybe.some(field);
				break;
			}
		}
		
		var expr = switch (createFunc.toOption())
		{
			case Option.Some(field):
				resolveLitllToEntity(type, field.type, field);
				
			case Option.None:
				macro HaxeEntityConstructorKind.New;
		}
		
		return macro HaxeEntityInterfaceKind.Class(
			new HaxeEntityClassInterface($expr)
		);
	}
    
    private static function resolveLitllToEntity(selfType:Type, type:Type, field:ClassField):Expr
    {
        return switch (type)
        {
            case Type.TFun(_, ret):
                var complexType = ret.toComplexType(); 
                var typePath = complexType.toString();
                var selfPath = selfType.toComplexType().toString();
                
                if (typePath.split("<")[0] == "hxext.ds.Result")
                {
                    switch (complexType)
                    {
                        case ComplexType.TPath(path):
                            switch (path.params)
                            {
                                case [TPType(ok), TPType(err)]:
                                    if (ok.toString() != selfPath)
                                    {
                                        Context.error("@:litllToEntity function requires Result<" + selfPath + ", LitllToEntityErrorKind>", field.pos);
                                    }
                                    else
                                    {
                                        switch (err.toString())
                                        {
                                            case "litll.idl.litll2entity.error.LitllToEntityErrorKind":
                                                macro HaxeEntityConstructorKind.Function($v{field.name}, HaxeEntityConstructorReturnKind.Result);	
                                                
                                            case _:
                                                Context.error("Error type must be litll.idl.litll2entity.error.LitllToEntityErrorKind", field.pos);
                                                return null;
                                        }
                                    }
                                case _:
                                    Context.error("Result type parameters are invalid", field.pos);
                                    null;
                            }
                            
                        case _:
                            Context.error("Result type parameters are invalid", field.pos);
                    }
                }
                else if (typePath == selfPath)
                {
                    macro HaxeEntityConstructorKind.Function($v{field.name}, HaxeEntityConstructorReturnKind.Direct);
                }
                else
                {
                    Context.error("@:litllToEntity function return type must be Result<" + selfPath + ", LitllToEntityErrorKind> or " + selfPath, field.pos);
                    null;
                }
                
            case TLazy(func):
                resolveLitllToEntity(selfType, func(), field);
                
            case _:
                Context.error("@:litllToEntity function must be function:", field.pos);
                null;
        }
    }
	#end
}
