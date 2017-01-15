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
import litll.idl.std.data.idl.TupleArgument;
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
using litll.idl.std.tools.idl.EnumConstructorHeaderTools;

class IdlToHaxeDataConverter
{
	public static function convertType(path:HaxeDataTypePath, source:IdlTypeDefinition, config:DataOutputConfig):HaxeTypeDefinition
	{
		var fields:Array<Field> = [];
		var kind:TypeDefKind;
		var name = TypeDefinitionTools.getTypeName(source);
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
							
						case EnumConstructor.Parameterized(header, _arguments):
							name = header.getHeaderName().toPascalCase().getOrThrow();
							arguments = convertTupleArguments(_arguments, config);
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
				
			case IdlTypeDefinition.Tuple(name, arguments):
				kind = TypeDefKind.TDClass(null, null, false);
				setupBasicFields(
					fields, 
					convertTupleArguments(arguments, config).concat(additionalFields)
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
	
	private static function convertArgument(argument:Argument, config:DataOutputConfig):FunctionArg
	{
        var typePath = ComplexType.TPath(argument.type.toMacroTypePath(config));
        typePath = switch (argument.name.kind)
        {
            case Normal | Unfold | Skippable:
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
				
		return {
            name: argument.name.toVariableName().getOrThrow(),
            type: typePath,
        };
	}
	private static function convertArguments(source:Array<Argument>, config:DataOutputConfig):Array<FunctionArg>
	{
		return [for (argument in source) convertArgument(argument, config)];
	}
    
	private static function convertTupleArguments(source:Array<TupleArgument>, config:DataOutputConfig):Array<FunctionArg>
	{
        var args = [];
        for (argument in source)
        {
            switch (argument)
            {
                case TupleArgument.Data(argument):
                    args.push(convertArgument(argument, config));
                    
                case TupleArgument.Label(_):
            }
        }
        
        return args;
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
