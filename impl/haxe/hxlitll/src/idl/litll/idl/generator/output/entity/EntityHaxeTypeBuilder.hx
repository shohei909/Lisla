package litll.idl.generator.output.entity;

import haxe.macro.Expr;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.TypeDefKind;
import hxext.ds.Maybe;
import litll.idl.exception.IdlException;
import litll.idl.generator.data.EntityOutputConfig;
import litll.idl.generator.output.EntityTypeInfomation;
import litll.idl.std.entity.idl.Argument;
import litll.idl.std.entity.idl.ArgumentKind;
import litll.idl.std.entity.idl.EnumConstructor;
import litll.idl.std.entity.idl.StructElement;
import litll.idl.std.entity.idl.StructElementKind;
import litll.idl.std.entity.idl.StructElementName;
import litll.idl.std.entity.idl.StructField;
import litll.idl.std.entity.idl.TupleElement;
import litll.idl.std.tools.idl.TypeDefinitionTools;
import litll.idl.std.tools.idl.TypeDependenceDeclarationTools;
import litll.idl.std.tools.idl.TypeNameTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationTools;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.entity.idl.TypeDefinition in IdlTypeDefinition;

class EntityHaxeTypeBuilder
{
	public static function convertType(type:EntityTypeInfomation, config:EntityOutputConfig):HaxeTypeDefinition
	{
        var source = type.definition;
        var path = type.haxePath;
        
        var meta:Array<MetadataEntry> = [];
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
				var convertedStructFields = convertStructElements(arguments, config).concat(additionalFields);
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
							name = constructor.name.toPascalCase().getOrThrow();
							arguments = convertTupleElements(constructor.elements, config);
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
                var typePath = type.toMacroTypePath(config);
                var haxeType = ComplexType.TPath(typePath);
				kind = TypeDefKind.TDAbstract(haxeType, [], [haxeType]);
                meta.push({ name:":forward", pos:null });
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
                if (type.getTypePath().isStringType() && additionalFields.length == 0)
                {
                    var abstractPath = path.toMacroPath();
                    fields.push(
                        {
                            name : "fromString",
                            kind : FieldType.FFun(
                                {
                                    args: [
                                        {
                                            name: "string",
                                            type: macro:String,
                                        },
                                        {
                                            name: "tag",
                                            opt: true,
                                            type: macro:hxext.ds.Maybe<litll.core.tag.StringTag>,
                                        },
                                    ],
                                    ret: null,
                                    expr: macro { return new $abstractPath(new $typePath(string, tag)); },
                                }
                            ),
                            access: [Access.APublic, Access.AStatic],
                            pos: null,
                        }
                    );
                }
                
			case IdlTypeDefinition.Tuple(name, arguments):
				kind = TypeDefKind.TDClass(null, null, false);
				setupBasicFields(
					fields, 
					convertTupleElements(arguments, config).concat(additionalFields)
				);
		}
		
		return {
            meta : meta,
			pack : path.getModuleArray(),
			name : path.typeName.toString(),
			params: params,
			pos : null,
			kind : kind,
			fields : fields,
		}
	}
	
	private static function convertArgument(argument:Argument, config:EntityOutputConfig):FunctionArg
	{
        var typePath = ComplexType.TPath(argument.type.toMacroTypePath(config));
        typePath = switch (argument.name.kind)
        {
            case ArgumentKind.Normal | ArgumentKind.Inline:
                typePath;
                
            case ArgumentKind.Optional | ArgumentKind.OptionalInline:
                ComplexType.TPath(
                    {
                        pack : ["haxe", "ds"],
                        name : "Option",
                        params : [TypeParam.TPType(typePath)],
                        sub : null
                    }
                );
                
            case ArgumentKind.Rest | ArgumentKind.RestInline:
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
	private static function convertField(field:StructField, config:EntityOutputConfig):FunctionArg
	{
        var typePath = ComplexType.TPath(field.type.toMacroTypePath(config));
        var name = field.name;
        
        typePath = switch (name.kind)
        {
            case StructElementKind.Normal | StructElementKind.Inline | StructElementKind.Merge:
                typePath;
                
            case StructElementKind.Optional | StructElementKind.OptionalInline:
                ComplexType.TPath(
                    {
                        pack : ["haxe", "ds"],
                        name : "Option",
                        params : [TypeParam.TPType(typePath)],
                        sub : null
                    }
                );
                
            case StructElementKind.Array | StructElementKind.ArrayInline:
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
    
	private static function convertStructElements(fields:Array<StructElement>, config:EntityOutputConfig):Array<FunctionArg>
	{
		var args:Array<FunctionArg> = [];
        inline function addLabel(name:StructElementName, tagKind:ComplexType):Void
        {
            var typePath = switch (name.kind)
            {
                case StructElementKind.Normal:
                    tagKind;
                    
                case StructElementKind.Array:
                    macro:Array<$tagKind>;
                    
                case StructElementKind.Optional:
                    macro:haxe.ds.Option<$tagKind>;
                    
                case StructElementKind.Inline:
                    throw new IdlException("inline suffix(<) for label is not supported");
                    
                case StructElementKind.ArrayInline:
                    throw new IdlException("array inline suffix(..<) for label is not supported");
                    
                case StructElementKind.OptionalInline:
                    throw new IdlException("optional inline suffix(?<) for label is not supported");
                    
                case StructElementKind.Merge:
                    throw new IdlException("merge suffix(<<) for label is not supported");
            }
            args.push(
                {
                    name : name.toVariableName().getOrThrow(),
                    type : typePath,
                }
            );
        }
        
        for (field in fields)
        {
            switch (field)
            {
                case StructElement.Field(field):
                    args.push(convertField(field, config));
                    
                case StructElement.Label(name):
                    addLabel(name, macro:hxext.ds.Maybe<litll.core.tag.StringTag>);
                    
                case StructElement.NestedLabel(name):
                    addLabel(name, macro:hxext.ds.Maybe<litll.core.tag.ArrayTag>);
            }
        }
        
        return args;
	}
    
	private static function convertTupleElements(source:Array<TupleElement>, config:EntityOutputConfig):Array<FunctionArg>
	{
        var args = [];
        for (argument in source)
        {
            switch (argument)
            {
                case TupleElement.Argument(argument):
                    args.push(convertArgument(argument, config));
                    
                case TupleElement.Label(_):
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
