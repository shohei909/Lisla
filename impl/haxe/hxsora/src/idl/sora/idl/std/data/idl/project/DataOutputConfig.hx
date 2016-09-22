package sora.idl.std.data.idl.project;
import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.Type.BaseType;
import sora.core.Sora;
import sora.core.SoraArray;
import sora.core.SoraString;
import sora.idl.project.output.path.HaxeDataTypePath;
import sora.idl.project.output.store.HaxeDataClassInterface;
import sora.idl.project.output.store.HaxeDataEnumInterface;
import sora.idl.project.output.store.HaxeDataInterface;
import sora.idl.project.output.store.HaxeDataInterfaceKind;
import sora.idl.std.data.idl.ModulePath;
import sora.idl.std.data.idl.TypeName;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.path.TypeGroupPath;
import sora.idl.std.data.idl.path.TypePathFilter;

using sora.core.ds.ResultTools;
using sora.idl.std.tools.idl.path.TypePathFilterTools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using sora.core.ds.OptionTools;

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
			TypePathFilterTools.createPrefix("sora", "sora.idl.std.data"),
			TypePathFilterTools.createPrefix("Array", "sora.core.SoraArray"),
			TypePathFilterTools.createPrefix("String", "sora.core.SoraString"),
			TypePathFilterTools.createPrefix("sora.core.Any", "sora.core.Sora"),
			TypePathFilterTools.createPrefix("sora.core.Option", "sora.idl.std.data.core.SoraOption"),
			TypePathFilterTools.createPrefix("sora.core.Single", "sora.idl.std.data.core.SoraSingle"),
			TypePathFilterTools.createPrefix("sora.core.Int64", "sora.idl.std.data.core.SoraInt64"),
			TypePathFilterTools.createPrefix("sora.core.Int32", "sora.idl.std.data.core.SoraInt32"),
			TypePathFilterTools.createPrefix("sora.core.Int16", "sora.idl.std.data.core.SoraInt16"),
			TypePathFilterTools.createPrefix("sora.core.Int8", "sora.idl.std.data.core.SoraInt8"),
			TypePathFilterTools.createPrefix("sora.core.UInt64", "sora.idl.std.data.core.SoraUInt64"),
			TypePathFilterTools.createPrefix("sora.core.UInt32", "sora.idl.std.data.core.SoraUInt32"),
			TypePathFilterTools.createPrefix("sora.core.UInt16", "sora.idl.std.data.core.SoraUInt16"),
			TypePathFilterTools.createPrefix("sora.core.UInt8", "sora.idl.std.data.core.SoraUInt8"),
			TypePathFilterTools.createPrefix("sora.core.Map", "sora.idl.std.data.core.SoraMap"),
			TypePathFilterTools.createPrefix("sora.core.Boolean", "sora.idl.std.data.core.SoraBoolean"),
			TypePathFilterTools.createPrefix("sora.core.Float64", "sora.idl.std.data.core.SoraFloat64"),
			TypePathFilterTools.createPrefix("sora.core.Date", "sora.idl.std.data.core.SoraDate"),
			TypePathFilterTools.createPrefix("sora.core.Time", "sora.idl.std.data.core.SoraTime"),
			TypePathFilterTools.createPrefix("sora.core.DateTime", "sora.idl.std.data.core.SoraDateTime"),
		].concat(filters);
		
		predefinedTypes = new Map();
		
		this.addPredefinedType(Sora);
		this.addPredefinedType(SoraArray);
		this.addPredefinedType(SoraString);
		this.addPredefinedType(ArgumentName);
		this.addPredefinedType(EnumConstructorName);
		this.addPredefinedType(ModulePath);
		this.addPredefinedType(PackagePath);
		this.addPredefinedType(TypeName);
		this.addPredefinedType(TypePath);
		this.addPredefinedType(TypeDependenceName);
		this.addPredefinedType(UnionConstructorName);
	}
	
	public function toHaxeDataPath(typePath:TypePath):HaxeDataTypePath
	{
		var l = filters.length;
		for (i in 0...l)
		{
			var filter = filters[l - i - 1];
			switch (filter.apply(typePath))
			{
				case Option.Some(convertedPath):
					typePath = convertedPath;
					break;
					
				case Option.None:
			}
		}
		
		return new HaxeDataTypePath(typePath);
	}
	
	public function addPredefinedTypeDirectly(path:String, data:sora.idl.project.output.store.HaxeDataInterface):Void
	{
		predefinedTypes[path] = data;
	}
	
	#end
	
	public macro function addPredefinedType(_this:Expr, expr:Expr):Expr
	{
		var type = Context.getType(ExprTools.toString(expr));
		var typePathString:String = type.toComplexType().toString();
		var baseType:BaseType;
		
		var data:Expr = switch (type)
		{
			case TInst(ref, params):
				addPredefinedClass(baseType = ref.get(), params);
				
			case TAbstract(ref, params):
				addPredefinedClass(baseType = ref.get(), params);
		
			case TEnum(ref, params):
				baseType = ref.get();
				macro HaxeDataInterfaceKind.Enum(
					new HaxeDataEnumInterface()
				);
						
			case _: 
				throw "unsupported type " + type;
		}
		
		return macro $_this.addPredefinedTypeDirectly(
			$v{typePathString}, 
			new HaxeDataInterface(
				new HaxeDataTypePath(
					new TypePath(
						Option.Some(new ModulePath($v{baseType.pack})), 
						new TypeName($v{baseType.name})
					)
				),
				$data
			)
		);
	}
	
	#if macro
	private static function addPredefinedClass(ref:BaseType, params:Array<Type>):Expr
	{
		return macro HaxeDataInterfaceKind.Class(new HaxeDataClassInterface());
	}
	#end
}
