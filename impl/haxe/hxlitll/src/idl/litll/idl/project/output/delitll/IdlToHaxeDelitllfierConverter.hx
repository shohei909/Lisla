package litll.idl.project.output.delitll;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.exception.IdlException;
import litll.idl.project.error.IdlReadError;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.project.output.data.store.HaxeDataConstructorKind;
import litll.idl.project.output.delitll.HaxeDelitllfierTypePathPair;
import litll.idl.project.output.instance.LitllToHaxeInstanceConverter;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.data.idl.haxe.DelitllfierOutputConfig;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;

using litll.core.ds.ResultTools;
using litll.core.ds.MaybeTools;
using litll.idl.std.tools.idl.TypeReferenceTools;
using litll.idl.std.tools.idl.TypeDefinitionTools;
using litll.idl.std.tools.idl.TypeParameterDeclarationTools;

class IdlToHaxeDelitllfierConverter
{
	private var config:DelitllfierOutputConfig;
	private var context:IdlToHaxeConvertContext;
	
	private function new (context:IdlToHaxeConvertContext, config:DelitllfierOutputConfig)
	{
		this.context = context;
		this.config = config;
	}
	
	public static function convertType(pathPair:HaxeDelitllfierTypePathPair, source:IdlTypeDefinition, context:IdlToHaxeConvertContext, config:DelitllfierOutputConfig):HaxeTypeDefinition
	{
		return new IdlToHaxeDelitllfierConverter(context, config).run(pathPair, source);
	}
	
	private function run(pathPair:HaxeDelitllfierTypePathPair, source:IdlTypeDefinition):HaxeTypeDefinition
	{
		var params = TypeParameterDeclarationTools.toHaxeParams(TypeDefinitionTools.getTypeParameters(source));
		var args = [
			{
				name: "context",
				type: (macro : litll.idl.delitllfy.DelitllfyContext)
			}
		];
		for (arg in source.getTypeParameters().toHaxeDelitllfierArgs(context.dataOutputConfig))
		{
			args.push(arg);
		}
		
		var processExpr = switch (source)
		{
			case IdlTypeDefinition.Newtype(name, destType):
				createNewtypeExpr(pathPair.dataPath, destType.generalize());
				
			case IdlTypeDefinition.Struct(name, arguments):
				macro null;
			case IdlTypeDefinition.Enum(name, constructors):
				macro null;
			case IdlTypeDefinition.Union(name, constructors):
				macro null;
			case IdlTypeDefinition.Tuple(name, arguments):
				macro null;
		}
		
		var dataTypePath = ComplexType.TPath(
			{
				pack : pathPair.dataPath.getModuleArray(),
				name : pathPair.dataPath.typeName.toString(),
			}
		);
		return {
			pack : pathPair.delitllfierPath.getModuleArray(),
			name : pathPair.delitllfierPath.typeName.toString(),
			params: [], 
			pos : null,
			kind : TypeDefKind.TDClass(null, null, false),
			fields : [
				{
					name : "process",
					kind : FieldType.FFun(
						{
							args: args,
							ret: macro:litll.core.ds.Result<$dataTypePath, litll.idl.delitllfy.DelitllfyError>,
							expr: processExpr,
							params : params,
						}
					),
					access: [Access.APublic, Access.AStatic],
					pos: null,
				}
			],
		}
	}	
	
	private function createPathPair(typePath:TypePath):HaxeDelitllfierTypePathPair
	{
		return HaxeDelitllfierTypePathPair.create(typePath, context.dataOutputConfig, config);
	}
	
	private function createNewtypeExpr(sourcePath:HaxeDataTypePath, destType:GenericTypeReference):Expr 
	{
		var callExpr = createProcessCallExpr((macro context), destType);
		var instantiationExpr = createInstantiationExpr((macro data), destType);
		
		return macro {
			return switch ($callExpr)
			{
				case Result.Ok(data):
					$instantiationExpr;
					
				case Result.Err(error):
					Result.Err(error);
			}
		}
	}
	
	private function createProcessCallExpr(contextExpr:Expr, destType:GenericTypeReference):Expr
	{
		var data = createProcessFunc(destType);
		return macro $p{data.path}.process($a{[contextExpr].concat(data.args)});
	}
	
	private function createProcessFuncExpr(type:GenericTypeReference):Expr
	{
		var data = createProcessFunc(type);
		return if (data.args.length == 0)
		{
			macro $p{data.path}.process;
		}
		else
		{
			var underscore = macro _;
			macro $p{data.path}.process.bind($a{[underscore].concat(data.args)});
		}
	}
	
	private inline function createProcessFunc(type:GenericTypeReference):{path:Array<String>, args:Array<Expr>}
	{
		return {
			path: config.toHaxeDelitllfierPath(type.typePath).toArray(),
			args: [
				for (parameter in type.parameters)
				{
					switch (parameter.processedValue.getOrThrow(IdlException.new.bind("must be processed")))
					{	
						case TypeReferenceParameterKind.Type(type):
							createProcessFuncExpr(type.generalize());
							
						case TypeReferenceParameterKind.Dependence(type):
							LitllToHaxeInstanceConverter.convertType(parameter.value, type, context); 
					}
				}
			]
		}
	}
	
	private function createInstantiationExpr(dataExpr:Expr, destType:GenericTypeReference):Expr
	{
		var haxePath = context.dataOutputConfig.toHaxeDataPath(destType.typePath);
		var classInterface = context.interfaceStore.getDataClassInterface(haxePath).getOrThrow(IdlException.new.bind("class " + haxePath.toString() + " not found"));
		
		return switch (classInterface.delitllfier)
		{
			case HaxeDataConstructorKind.Direct(name):
				macro null;
				
			case HaxeDataConstructorKind.Result(name, err):
				macro null;
		}
	}
}
