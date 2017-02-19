package litll.idl.generator.data;
import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.Type.BaseType;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import hxext.ds.Maybe;
import litll.idl.generator.output.entity.EntityHaxeTypePath;
import litll.idl.generator.output.entity.store.HaxeEntityClassInterface;
import litll.idl.generator.output.entity.store.HaxeEntityConstructorKind;
import litll.idl.generator.output.entity.store.HaxeEntityConstructorReturnKind;
import litll.idl.generator.output.entity.store.HaxeEntityEnumInterface;
import litll.idl.generator.output.entity.store.HaxeEntityInterface;
import litll.idl.generator.output.entity.store.HaxeEntityInterfaceKind;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.PackagePath;
import litll.idl.std.data.idl.StructElementName;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.group.TypeGroupPath;
import litll.idl.std.data.idl.group.TypePathFilter;

using hxext.ds.ResultTools;
using litll.idl.std.tools.idl.path.TypePathFilterTools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using hxext.ds.MaybeTools;

class DataOutputConfig
{
	public var targets(default, null):Array<TypeGroupPath>;
	public var filters(default, null):Array<TypePathFilter>;
	public var predefinedTypes(default, null):Map<String, HaxeEntityInterface>;
	
	#if !macro
	public function new(targets:Array<TypeGroupPath>, filters:Array<TypePathFilter>) 
	{
		this.targets = targets;
		this.filters = [	
			TypePathFilterTools.createPrefix("litll", "litll.idl.std.data"),
			TypePathFilterTools.createPrefix("Array", "litll.core.LitllArray"),
			TypePathFilterTools.createPrefix("String", "litll.core.LitllString"),
			TypePathFilterTools.createPrefix("litll.core.Any", "litll.core.Litll"),
			TypePathFilterTools.createPrefix("litll.core.Option", "litll.idl.std.data.core.LitllOption"),
			TypePathFilterTools.createPrefix("litll.core.Single", "litll.idl.std.data.core.LitllSingle"),
			TypePathFilterTools.createPrefix("litll.core.Int64", "litll.idl.std.data.core.LitllInt64"),
			TypePathFilterTools.createPrefix("litll.core.Int32", "litll.idl.std.data.core.LitllInt32"),
			TypePathFilterTools.createPrefix("litll.core.Int16", "litll.idl.std.data.core.LitllInt16"),
			TypePathFilterTools.createPrefix("litll.core.Int8", "litll.idl.std.data.core.LitllInt8"),
			TypePathFilterTools.createPrefix("litll.core.UInt64", "litll.idl.std.data.core.LitllUInt64"),
			TypePathFilterTools.createPrefix("litll.core.UInt32", "litll.idl.std.data.core.LitllUInt32"),
			TypePathFilterTools.createPrefix("litll.core.UInt16", "litll.idl.std.data.core.LitllUInt16"),
			TypePathFilterTools.createPrefix("litll.core.UInt8", "litll.idl.std.data.core.LitllUInt8"),
			TypePathFilterTools.createPrefix("litll.core.Map", "litll.idl.std.data.core.LitllMap"),
			TypePathFilterTools.createPrefix("litll.core.Boolean", "litll.idl.std.data.core.LitllBoolean"),
			TypePathFilterTools.createPrefix("litll.core.Float64", "litll.idl.std.data.core.LitllFloat64"),
			TypePathFilterTools.createPrefix("litll.core.Date", "litll.idl.std.data.core.LitllDate"),
			TypePathFilterTools.createPrefix("litll.core.Time", "litll.idl.std.data.core.LitllTime"),
			TypePathFilterTools.createPrefix("litll.core.DateTime", "litll.idl.std.data.core.LitllDateTime"),
		].concat(filters);
		
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
		this.addPredefinedType(TypePathFilter);
	}
	#end
	
	public function toHaxeDataPath(typePath:TypePath):EntityHaxeTypePath
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
