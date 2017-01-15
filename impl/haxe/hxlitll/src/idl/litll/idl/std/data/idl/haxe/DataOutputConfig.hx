package litll.idl.std.data.idl.haxe;
import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.Type.BaseType;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.project.output.data.store.HaxeDataClassInterface;
import litll.idl.project.output.data.store.HaxeDataConstructorKind;
import litll.idl.project.output.data.store.HaxeDataConstructorReturnKind;
import litll.idl.project.output.data.store.HaxeDataEnumInterface;
import litll.idl.project.output.data.store.HaxeDataInterface;
import litll.idl.project.output.data.store.HaxeDataInterfaceKind;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.path.TypeGroupPath;
import litll.idl.std.data.idl.path.TypePathFilter;

using litll.core.ds.ResultTools;
using litll.idl.std.tools.idl.path.TypePathFilterTools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using litll.core.ds.MaybeTools;

class DataOutputConfig
{
	#if !macro
	public var targets(default, null):Array<TypeGroupPath>;
	public var filters(default, null):Array<TypePathFilter>;
	public var predefinedTypes(default, null):Map<String, HaxeDataInterface>;
	
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
	}
	
	public function toHaxeDataPath(typePath:TypePath):HaxeDataTypePath
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
		
		return new HaxeDataTypePath(typePath);
	}
	
	public function addPredefinedTypeDirectly(path:String, data:litll.idl.project.output.data.store.HaxeDataInterface):Void
	{
		predefinedTypes[path] = data;
	}
	
	#end
	
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
				macro HaxeDataInterfaceKind.Enum(
					new HaxeDataEnumInterface()
				);
						
			case _: 
				throw "unsupported type " + type;
		}
		
		var typePathString:String = baseType.pack.concat([baseType.name]).join(".");
		return macro $_this.addPredefinedTypeDirectly(
			$v{typePathString}, 
			new HaxeDataInterface(
				new HaxeDataTypePath(
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
			if (field.meta.has(":delitllfy"))
			{
				createFunc = Maybe.some(field);
				break;
			}
		}
		
		var expr = switch (createFunc.toOption())
		{
			case Option.Some(field):
				resolveDelitllfy(type, field.type, field);
				
			case Option.None:
				macro HaxeDataConstructorKind.New;
		}
		
		return macro HaxeDataInterfaceKind.Class(
			new HaxeDataClassInterface($expr)
		);
	}
    
    private static function resolveDelitllfy(selfType:Type, type:Type, field:ClassField):Expr
    {
        return switch (type)
        {
            case Type.TFun(_, ret):
                var complexType = ret.toComplexType(); 
                var typePath = complexType.toString();
                var selfPath = selfType.toComplexType().toString();
                
                if (typePath.split("<")[0] == "litll.core.ds.Result")
                {
                    switch (complexType)
                    {
                        case ComplexType.TPath(path):
                            switch (path.params)
                            {
                                case [TPType(ok), TPType(err)]:
                                    if (ok.toString() != selfPath)
                                    {
                                        Context.error("@:delitllfy function requires Result<" + selfPath + ", DelitllfyErrorKind>", field.pos);
                                    }
                                    else
                                    {
                                        switch (err.toString())
                                        {
                                            case "litll.idl.delitllfy.DelitllfyErrorKind":
                                                macro HaxeDataConstructorKind.Function($v{field.name}, HaxeDataConstructorReturnKind.Result);	
                                                
                                            case _:
                                                Context.error("Error type must be litll.idl.delitllfy.DelitllfyErrorKind", field.pos);
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
                    macro HaxeDataConstructorKind.Function($v{field.name}, HaxeDataConstructorReturnKind.Direct);
                }
                else
                {
                    Context.error("@:delitllfy function return type must be Result<" + selfPath + ", DelitllfyErrorKind> or " + selfPath, field.pos);
                    null;
                }
                
            case TLazy(func):
                resolveDelitllfy(selfType, func(), field);
                
            case _:
                Context.error("@:delitllfy function must be function:", field.pos);
                null;
        }
    }
	#end
}
