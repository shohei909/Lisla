package litll.idl.project.output;

import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.Delitllfier;
import litll.idl.project.output.IdlToHaxePrintContext;
import litll.idl.project.output.path.HaxeDataTypePath;
import litll.idl.project.output.path.HaxeDelitllfierTypePath;
import litll.idl.project.output.path.HaxeDelitllfierTypePathPair;
import litll.idl.project.source.IdlSourceProviderImpl;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.project.DataOutputConfig;
import litll.idl.std.data.idl.project.DelitllfierOutputConfig;
import litll.idl.std.tools.idl.TypeDefinitionTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationTools;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;
using litll.core.ds.ResultTools;
using litll.core.ds.OptionTools;
using litll.idl.std.tools.idl.TypeReferenceTools;

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
									type: (macro : litll.idl.delitllfy.DelitllfyContext)
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
	
	private function createPathPair(typePath:TypePath):HaxeDelitllfierTypePathPair
	{
		return HaxeDelitllfierTypePathPair.create(typePath, context.dataOutputConfig, config);
	}
	
	private static function createAliasExpr(sourcePath:HaxeDataTypePath, destType:TypeReference):Expr 
	{
		return macro null;
	}
}
