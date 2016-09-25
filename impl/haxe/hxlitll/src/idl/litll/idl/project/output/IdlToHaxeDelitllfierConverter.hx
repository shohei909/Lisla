package litll.idl.project.output;

import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.Litllfier;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.project.output.path.HaxeDataTypePath;
import litll.idl.project.output.path.HaxeLitllfierTypePath;
import litll.idl.project.output.path.HaxeLitllfierTypePathPair;
import litll.idl.project.source.IdlSourceProviderImpl;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.project.DataOutputConfig;
import litll.idl.std.data.idl.project.LitllfierOutputConfig;
import litll.idl.std.tools.idl.TypeDefinitionTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationTools;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;
using litll.core.ds.ResultTools;
using litll.core.ds.OptionTools;
using litll.idl.std.tools.idl.TypeReferenceTools;

class IdlToHaxeLitllfierConverter
{
	private var config:LitllfierOutputConfig;
	private var context:IdlToHaxeConvertContext;
	
	private function new (context:IdlToHaxeConvertContext, config:LitllfierOutputConfig)
	{
		this.context = context;
		this.config = config;
	}
	
	public static function convertType(pathPair:HaxeLitllfierTypePathPair, source:IdlTypeDefinition, context:IdlToHaxeConvertContext, config:LitllfierOutputConfig):HaxeTypeDefinition
	{
		return new IdlToHaxeLitllfierConverter(context, config).run(pathPair, source);
	}
	
	private function run(pathPair:HaxeLitllfierTypePathPair, source:IdlTypeDefinition):HaxeTypeDefinition
	{
		var processExpr = macro null;
		switch (source)
		{
			case IdlTypeDefinition.Alias(name, destType):
				createAliasExpr(pathPair.dataPath, destType);
				
			case IdlTypeDefinition.Struct(name, arguments):
			case IdlTypeDefinition.Enum(name, constructors):
			case IdlTypeDefinition.Union(name, constructors):
			case IdlTypeDefinition.Tuple(name, arguments):
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
							args: [
								{
									name: "context",
									type: (macro : litll.idl.delitllfy.LitllContext)
								}
							],
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
	
	private function createPathPair(typePath:TypePath):HaxeLitllfierTypePathPair
	{
		return HaxeLitllfierTypePathPair.create(typePath, context.dataOutputConfig, config);
	}
	
	private static function createAliasExpr(sourcePath:HaxeDataTypePath, destType:TypeReference):Expr 
	{
		return macro null;
	}
}
