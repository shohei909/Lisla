package litll.idl.project.output.delitll;

import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.project.output.delitll.HaxeDelitllfierTypePathPair;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.haxe.DelitllfierOutputConfig;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;

using litll.core.ds.ResultTools;
using litll.core.ds.OptionTools;
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
		var args = [
			{
				name: "context",
				type: (macro : litll.idl.delitllfy.DelitllfyContext)
			}
		];
		for (dependence in source.getTypeParameters().toHaxeDependences(context.dataOutputConfig))
		{
			args.push(dependence);
		}
		
		var processExpr = switch (source)
		{
			case IdlTypeDefinition.Alias(name, destType):
				createAliasExpr(pathPair.dataPath, destType);
				
			case IdlTypeDefinition.Struct(name, arguments):
				macro null;
			case IdlTypeDefinition.Enum(name, constructors):
				macro null;
			case IdlTypeDefinition.Union(name, constructors):
				macro null;
			case IdlTypeDefinition.Tuple(name, arguments):
				macro null;
		}
		
		
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
							ret: null,
							expr: processExpr,
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
	
	private function createProcessCall(contextExpr:Expr, destType:TypeReference):Expr
	{
		return switch (destType)
		{
			case TypeReference.Primitive(primitive):
				var path = primitive.toArray();
				macro $p{path}.process($contextExpr);
				
			case TypeReference.Generic(generic):
				var path = generic.typePath.toArray();
				var args = [contextExpr];
				for (parameters in generic.parameters)
				{
				}
				macro $p{path}.process($a{args});
		}
	}
	
	private function createAliasExpr(sourcePath:HaxeDataTypePath, destType:TypeReference):Expr 
	{
		return createProcessCall((macro context), destType);
	}
}
