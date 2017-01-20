package litll.idl.project.output.data;

import haxe.macro.Expr;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.TypeDefKind;
import litll.idl.exception.IdlException;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.std.data.core.LitllBoolean;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentKind;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.StructField;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.StructFieldName;
import litll.idl.std.data.idl.TupleArgument;
import litll.idl.std.data.idl.TypeReference;
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
using litll.idl.std.tools.idl.StructFieldHeaderTools;

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
				var convertedStructFields = convertStructFields(arguments, config).concat(additionalFields);
				setupBasicFields(fields, convertedStructFields);
				
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
							
						case EnumConstructor.Parameterized(constructor):
							name = constructor.header.getHeaderName().toPascalCase().getOrThrow();
							arguments = convertTupleArguments(constructor.arguments, config);
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
            case ArgumentKind.Normal | ArgumentKind.Unfold:
                typePath;
                
            case ArgumentKind.Optional:
                ComplexType.TPath(
                    {
                        pack : ["haxe", "ds"],
                        name : "Option",
                        params : [TypeParam.TPType(typePath)],
                        sub : null
                    }
                );
                
            case ArgumentKind.Rest:
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
	private static function convertField(name:StructFieldName, type:TypeReference, config:DataOutputConfig):FunctionArg
	{
        var typePath = ComplexType.TPath(type.toMacroTypePath(config));
        typePath = switch (name.kind)
        {
            case StructFieldKind.Normal | StructFieldKind.Unfold:
                typePath;
                
            case StructFieldKind.Optional:
                ComplexType.TPath(
                    {
                        pack : ["haxe", "ds"],
                        name : "Option",
                        params : [TypeParam.TPType(typePath)],
                        sub : null
                    }
                );
                
            case StructFieldKind.Rest:
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
            name: name.toVariableName().getOrThrow(),
            type: typePath,
        };
	}
    
	private static function convertStructFields(fields:Array<StructField>, config:DataOutputConfig):Array<FunctionArg>
	{
		var args = [];
        for (field in fields)
        {
            switch (field)
            {
                case StructField.Field(header, type):
                    args.push(convertField(header.getHeaderName(), type, config));
                    
                case StructField.Boolean(name):
                    var typePath = switch (name.kind)
                    {
                        case StructFieldKind.Normal:
                            macro:litll.idl.std.data.core.LitllBoolean;
                            
                        case StructFieldKind.Unfold:
                            throw new IdlException("unfold suffix(?) for boolean is not supported");
                            
                        case StructFieldKind.Optional:
                            throw new IdlException("optional suffix(?) for boolean is not supported");
                            
                        case StructFieldKind.Rest:
                            macro:Array<litll.idl.std.data.core.LitllBoolean>;
                    }
                    
                    args.push(
                        {
                            name : name.toVariableName().getOrThrow(),
                            type : typePath,
                        }
                    );
            }
        }
        
        return args;
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
