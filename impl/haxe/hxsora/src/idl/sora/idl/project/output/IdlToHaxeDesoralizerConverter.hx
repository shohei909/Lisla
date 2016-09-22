package sora.idl.project.output;

import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import sora.core.Sora;
import sora.core.ds.Result;
import sora.idl.desoralize.Desoralizer;
import sora.idl.project.output.IdlToHaxePrintContext;
import sora.idl.project.output.path.HaxeDataTypePath;
import sora.idl.project.output.path.HaxeDesoralizerTypePath;
import sora.idl.project.output.path.HaxeDesoralizerTypePathPair;
import sora.idl.project.source.IdlSourceProviderImpl;
import sora.idl.std.data.idl.TypeName;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.TypeReference;
import sora.idl.std.data.idl.project.DataOutputConfig;
import sora.idl.std.data.idl.project.DesoralizerOutputConfig;
import sora.idl.std.tools.idl.TypeDefinitionTools;
import sora.idl.std.tools.idl.TypeParameterDeclarationTools;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import sora.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;
using sora.core.ds.ResultTools;
using sora.core.ds.OptionTools;
using sora.idl.std.tools.idl.TypeReferenceTools;

class IdlToHaxeDesoralizerConverter
{
	private var config:DesoralizerOutputConfig;
	private var context:IdlToHaxeConvertContext;
	
	private function new (context:IdlToHaxeConvertContext, config:DesoralizerOutputConfig)
	{
		this.context = context;
		this.config = config;
	}
	
	public static function convertType(pathPair:HaxeDesoralizerTypePathPair, source:IdlTypeDefinition, context:IdlToHaxeConvertContext, config:DesoralizerOutputConfig):HaxeTypeDefinition
	{
		return new IdlToHaxeDesoralizerConverter(context, config).run(pathPair, source);
	}
	
	private function run(pathPair:HaxeDesoralizerTypePathPair, source:IdlTypeDefinition):HaxeTypeDefinition
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
			pack : pathPair.desoralizerPath.getModuleArray(),
			name : pathPair.desoralizerPath.typeName.toString(),
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
									type: (macro : sora.idl.desoralize.DesoralizeContext)
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
	
	private function createPathPair(typePath:TypePath):HaxeDesoralizerTypePathPair
	{
		return HaxeDesoralizerTypePathPair.create(typePath, context.dataOutputConfig, config);
	}
	
	private static function createAliasExpr(sourcePath:HaxeDataTypePath, destType:TypeReference):Expr 
	{
		return macro null;
	}
}
