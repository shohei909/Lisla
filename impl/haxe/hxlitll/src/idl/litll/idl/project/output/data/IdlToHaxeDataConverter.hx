package litll.idl.project.output.data;

import haxe.macro.Expr;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.TypeDefKind;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.haxe.DataOutputConfig;
import litll.idl.std.tools.idl.TypeDefinitionTools;
import litll.idl.std.tools.idl.TypeDependenceDeclarationTools;
import litll.idl.std.tools.idl.TypeNameTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationTools;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;

using litll.core.ds.MaybeTools;
using litll.core.ds.ResultTools;
using litll.idl.std.tools.idl.TypeReferenceTools;

class IdlToHaxeDataConverter
{
	public static function convertType(path:HaxeDataTypePath, source:IdlTypeDefinition, config:DataOutputConfig):HaxeTypeDefinition
	{
		var fields:Array<Field> = [];
		var kind:TypeDefKind;
		var name = TypeDefinitionTools.getName(source);
        var collection = TypeParameterDeclarationTools.collect(TypeDefinitionTools.getTypeParameters(source));
		var params = TypeNameTools.toHaxeParamDecls(collection.parameters);
		var additionalFields = TypeDependenceDeclarationTools.toHaxeDependences(collection.dependences, config);
	
		switch (source)
		{
			case IdlTypeDefinition.Struct(name, arguments):
				kind = TypeDefKind.TDClass(null, null, false);
				var convertedArguments = convertArguments(arguments, config).concat(additionalFields);
				setupBasicFields(fields, convertedArguments);
				
			case IdlTypeDefinition.Enum(name, constructors):
				kind = TypeDefKind.TDEnum;
				for (constructor in constructors)
				{
					var arguments;
					var name;
					switch (constructor)
					{
						case EnumConstructor.Primitive(primitive):
							name = primitive.toPascalCase().getOrThrow();
							arguments = [];
							
						case Parameterized(paramerterized):
							name = paramerterized.name.toPascalCase().getOrThrow();
							arguments = convertArguments(paramerterized.arguments, config);
					}
					
					arguments = arguments.concat(additionalFields);
					fields.push(
						{
							name : name,
							kind : if (arguments.length == 0)
							{
								FieldType.FVar(null, null);
							}
							else
							{
								FieldType.FFun(
									{
										args: arguments,
										ret: null,
										expr: null,
									}
								);
							},
							pos : null,
						}
					);
				}
				
				
			case IdlTypeDefinition.Newtype(name, type):
				var haxeType = ComplexType.TPath(type.toMacroTypePath(config));
				kind = TypeDefKind.TDAbstract(haxeType, [], [haxeType]);
				fields.push(
					createNew(
						[
							{
								name: "value",
								type: haxeType,
							}
						].concat(additionalFields),
						(macro {this = value;})
					)
				);
				
				
			case IdlTypeDefinition.Union(name, constructors):
				kind = TypeDefKind.TDEnum;
				for (constructor in constructors)
				{
					fields.push(
						{
							name: constructor.name.toPascalCase(),
							kind: FieldType.FFun(
								{
									args: [
										{
											name: constructor.name.toVariableName(),
											type: ComplexType.TPath(constructor.type.toMacroTypePath(config)),
										}
									].concat(additionalFields),
									ret: null,
									expr: null,
								}
							),
							pos : null,
						}
					);
				}
				
				
			case IdlTypeDefinition.Tuple(name, arguments):
				kind = TypeDefKind.TDClass(null, null, false);
				setupBasicFields(
					fields, 
					convertArguments(arguments, config).concat(additionalFields)
				);
		}
		
		return {
			pack : path.getModuleArray(),
			name : path.typeName.toString(),
			params: params,
			pos : null,
			kind : kind,
			fields : fields,
		}
	}
	
	private static function convertArguments(source:Array<Argument>, config:DataOutputConfig):Array<FunctionArg>
	{
		return [
			for (argument in source)
			{
				var typePath = ComplexType.TPath(argument.type.toMacroTypePath(config));
				typePath = switch (argument.name.kind)
				{
					case Normal | Structure | Skippable:
						typePath;
						
					case Rest:
						ComplexType.TPath(
							{
								pack : [],
								name : "Array",
								params : [TypeParam.TPType(typePath)],
								sub : null
							}
						);
				}
				
				{
					name: argument.name.toVariableName().getOrThrow(),
					type: typePath,
				}
			}
		];
	}
	
	private static function setupBasicFields(fields:Array<Field>, arguments:Array<FunctionArg>):Void
	{
		var exprs = [];
		for (argument in arguments)
		{
			var name = argument.name;
			fields.push(
				{
					name : name,
					kind : FieldType.FVar(argument.type),
					access: [Access.APublic],
					pos: null,
				}
			);
			var expr = (macro this.$name = $i{name});
			exprs.push(expr);
		}
		fields.push(
			createNew(
				arguments, 
				(macro $b{exprs})
			)
		);
	}
	
	private static function createNew(args:Array<FunctionArg>, expr:Expr):Field
	{
		return {
			name : "new",
			kind : FieldType.FFun(
				{
					args: args,
					ret: null,
					expr: expr,
				}
			),
			access: [Access.APublic],
			pos: null,
		};
	}
}
