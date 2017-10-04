package arraytree.idl.generator.data;
import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.Type.BaseType;
import hxext.ds.Maybe;
import arraytree.data.meta.core.ArrayWithMetadata;
import arraytree.data.tree.al.AlTree;
import arraytree.data.meta.core.StringWithMetadata;
import arraytree.idl.generator.output.entity.EntityHaxeTypePath;
import arraytree.idl.generator.output.entity.store.HaxeEntityClassInterface;
import arraytree.idl.generator.output.entity.store.HaxeEntityConstructorKind;
import arraytree.idl.generator.output.entity.store.HaxeEntityConstructorReturnKind;
import arraytree.idl.generator.output.entity.store.HaxeEntityEnumInterface;
import arraytree.idl.generator.output.entity.store.HaxeEntityInterface;
import arraytree.idl.generator.output.entity.store.HaxeEntityInterfaceKind;
import arraytree.idl.std.entity.idl.ArgumentName;
import arraytree.idl.std.entity.idl.EnumConstructorName;
import arraytree.idl.std.entity.idl.ModulePath;
import arraytree.idl.std.entity.idl.PackagePath;
import arraytree.idl.std.entity.idl.StructElementName;
import arraytree.idl.std.entity.idl.TypeDependenceName;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.idl.std.entity.idl.TypeReferenceParameter;
import arraytree.idl.std.entity.idl.group.TypeGroupFilter;
import arraytree.idl.std.entity.idl.group.TypeGroupPath;
import arraytree.idl.std.entity.idl.library.LibraryConfig;
import arraytree.idl.std.tools.idl.group.TypeGroupFilterTools;
using hxext.ds.ResultTools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;

class EntityOutputConfig
{
    public var noOutput:Bool;
	public var filters(default, null):Array<TypeGroupFilter>;
	public var predefinedTypes(default, null):Map<String, HaxeEntityInterface>;
	
	#if !macro
	public function new(noOutput:Bool, filters:Array<TypeGroupFilter>) 
	{
		this.noOutput = noOutput;
        this.filters = filters.concat(
            [
                TypeGroupFilterTools.create("Array",          "arraytree.data.meta.core.ArrayWithMetadata"),
                TypeGroupFilterTools.create("String",         "arraytree.data.meta.core.StringWithMetadata"),
                TypeGroupFilterTools.create("arraytree.core.Any", "arraytree.data.tree.al.AlTree"),
            ]
        );
		
		predefinedTypes = new Map();
		
		this.addPredefinedType(AlTree);
		this.addPredefinedType(ArrayWithMetadata);
		this.addPredefinedType(StringWithMetadata);
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
	
	public function addPredefinedTypeDirectly(path:String, data:arraytree.idl.generator.output.entity.store.HaxeEntityInterface):Void
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
						new TypeName(new StringWithMetadata($v{baseType.name}))
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
			if (field.meta.has(":arraytreeToEntity"))
			{
				createFunc = Maybe.some(field);
				break;
			}
		}
		
		var expr = switch (createFunc.toOption())
		{
			case Option.Some(field):
				resolveArrayTreeToEntity(type, field.type, field);
				
			case Option.None:
				macro HaxeEntityConstructorKind.New;
		}
		
		return macro HaxeEntityInterfaceKind.Class(
			new HaxeEntityClassInterface($expr)
		);
	}
    
    private static function resolveArrayTreeToEntity(selfType:Type, type:Type, field:ClassField):Expr
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
                                        Context.error("@:arraytreeToEntity function requires Result<" + selfPath + ", ArrayTreeToEntityErrorKind>", field.pos);
                                    }
                                    else
                                    {
                                        switch (err.toString())
                                        {
                                            case "arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind":
                                                macro HaxeEntityConstructorKind.Function($v{field.name}, HaxeEntityConstructorReturnKind.Result);	
                                                
                                            case _:
                                                Context.error("Error type must be arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind", field.pos);
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
                    Context.error("@:arraytreeToEntity function return type must be Result<" + selfPath + ", ArrayTreeToEntityErrorKind> or " + selfPath, field.pos);
                    null;
                }
                
            case TLazy(func):
                resolveArrayTreeToEntity(selfType, func(), field);
                
            case _:
                Context.error("@:arraytreeToEntity function must be function:", field.pos);
                null;
        }
    }
	#end
}
