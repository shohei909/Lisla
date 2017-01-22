package litll.idl.project.output.delitll;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.exception.IdlException;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.project.output.data.store.HaxeDataConstructorKind;
import litll.idl.project.output.data.store.HaxeDataConstructorReturnKind;
import litll.idl.project.output.delitll.HaxeDelitllfierTypePathPair;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentKind;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorKind;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.StructFieldName;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.data.idl.UnfoldedTypeDefinition;
import litll.idl.std.data.idl.haxe.DelitllfierOutputConfig;
import litll.idl.std.tools.idl.TypeNameTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;

using litll.core.ds.ResultTools;
using litll.core.ds.MaybeTools;
using litll.idl.std.tools.idl.TypeReferenceTools;
using litll.idl.std.tools.idl.TypeDefinitionTools;
using litll.idl.std.tools.idl.TypeParameterDeclarationTools;
using litll.idl.std.tools.idl.TypeNameDeclarationTools;

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
		var parameters:TypeParameterDeclarationCollection;
		var processExpr = switch (source)
		{
			case IdlTypeDefinition.Newtype(name, destType):
                parameters = name.getParameters().collect();
				createNewtypeExpr(pathPair.dataPath, parameters, destType.generalize());
				
			case IdlTypeDefinition.Tuple(name, elements):
				parameters = name.getParameters().collect();
				createTupleExpr(pathPair.dataPath, parameters, elements);
                
			case IdlTypeDefinition.Enum(name, constructors):
				parameters = name.getParameters().collect();
                createEnumExpr(pathPair.dataPath, parameters, constructors);
				
			case IdlTypeDefinition.Struct(name, elements):
				parameters = name.getParameters().collect();
				createStructExpr(pathPair.dataPath, parameters, elements);
		}
	
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
        
		var dataTypePath = ComplexType.TPath(
			{
				pack : pathPair.dataPath.getModuleArray(),
				name : pathPair.dataPath.typeName.toString(),
                params : TypeNameTools.toHaxeParams(parameters.parameters)
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
							params : TypeNameTools.toHaxeParamDecls(parameters.parameters),
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
	
    // ==============================================================
    // common
    // ==============================================================
    private function createClassInstantiationExpr(contextExpr:Expr, argumentDeclarations:Array<Expr>, argumentReferences:Array<Expr>, sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection):Expr
    {
        var classInterface = context.interfaceStore.getDataClassInterface(sourcePath).getOrThrow(IdlException.new.bind("class " + sourcePath.toString() + " not found"));
        for (dependence in parameters.dependences)
        {
            argumentReferences.push(macro $i{dependence.name.toVariableName()});
        }
        
        return switch (classInterface.delitllfier)
        {
            case HaxeDataConstructorKind.New:
                var sourceTypePath = sourcePath.toMacroPath();
                var blockBody = argumentDeclarations.concat(
                    [
                        (macro var instance = new $sourceTypePath($a{argumentReferences})),
                        (macro litll.core.ds.Result.Ok(instance)),
                    ]
                );
                macro { $a{blockBody} }
                
            case HaxeDataConstructorKind.Function(name, HaxeDataConstructorReturnKind.Direct):
                var blockBody = argumentDeclarations.concat(
                    [
                        (macro var instance = $i{sourcePath.toString()}.$name($a{argumentReferences})),
                        (macro litll.core.ds.Result.Ok(instance)),
                    ]
                );
                macro { $a{blockBody} }
                
            case HaxeDataConstructorKind.Function(name, HaxeDataConstructorReturnKind.Result):
                var blockBody = argumentDeclarations.concat(
                    [
                        macro switch ($i{sourcePath.toString()}.$name($a{argumentReferences}))
                        {
                            case litll.core.ds.Result.Ok(ok):
                                litll.core.ds.Result.Ok(ok);
                                
                            case litll.core.ds.Result.Err(err):
                                litll.core.ds.Result.Err(
                                    litll.idl.delitllfy.DelitllfyError.ofLitll(
                                        $contextExpr.litll, 
                                        err
                                    )
                                );
                        }
                    ]
                );
                macro { $a{blockBody} }
                
        }
	}
    private function createEnumInstantiationExpr(argumentDeclaration:Array<Expr>, argumentReferences:Array<Expr>, sourcePath:HaxeDataTypePath, name:EnumConstructorName, parameters:TypeParameterDeclarationCollection):Expr 
    {
        for (dependence in parameters.dependences)
        {
            argumentReferences.push(macro $i{dependence.name.toVariableName()});
        }
        
        var sourceTypePath = sourcePath.toString();
        var constructorName = name.toPascalCase().getOrThrow();
        
        return if (argumentReferences.length == 0)
        {
            macro litll.core.ds.Result.Ok($i{sourceTypePath}.$constructorName);
        }
        else
        {
            var blockBody = argumentDeclaration.concat(
                [
                    (macro litll.core.ds.Result.Ok($i{sourceTypePath}.$constructorName($a{argumentReferences})))
                ]
            );
            
            macro { $a{blockBody} }
        }
    }
	private function createProcessCallExpr(contextExpr:Expr, parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
	{
        var funcName = createProcessFuncNameExpr(parameters, destType);
        var processElements = [contextExpr].concat(createParmetersExpr(destType.parameters));
        return macro $funcName($a{processElements});
    }
	private function createProcessFuncExpr(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
	{
        var funcName = createProcessFuncNameExpr(parameters, destType);
        var processElements = createParmetersExpr(destType.parameters);
        
        return if (processElements.length == 0)
        {
            macro $funcName;
        }
        else
        {
            var args = [macro _].concat(processElements);
            macro $funcName.bind($a{args});
        }
    }
    private function createProcessFuncNameExpr(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
    {
        return switch (searchTypeParameter(parameters, destType))
        {
            case Option.Some(typeParameter):
                var funcName = typeParameter.toProcessFunctionName();
                macro $i{funcName};
                
            case Option.None:
                var haxePath = config.toHaxeDelitllfierPath(destType.typePath);
                macro $i{haxePath.toString()}.process;
        }
    }
    private function searchTypeParameter(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Option<TypeName>
    {
        for (i in 0...parameters.parameters.length)
        {
            if (parameters.parameters[i].toString() == destType.typePath.toString())
            {
                return Option.Some(parameters.parameters[i]);
            }
        }
        
        return Option.None;
    }
    private function createParmetersExpr(parameters:Array<TypeReferenceParameter>):Array<Expr>
    {
        var result = [];
        for (parameter in parameters)
        {
            var expr = switch (parameter.processedValue.getOrThrow(IdlException.new.bind("parameter must be processed")))
            {
                case TypeReferenceParameterKind.Type(type):
                    var typeName = config.toHaxeDelitllfierPath(type.getTypePath()).toString();
                    switch (type)
                    {
                        case TypeReference.Primitive(primitive):
                            macro $i{typeName}.process;
                            
                        case TypeReference.Generic(generic):
                            var childParametersExpr = [macro _].concat(createParmetersExpr(generic.parameters));
                            macro $i{typeName}.process.bind($a{childParametersExpr});
                    }
                    
                case TypeReferenceParameterKind.Dependence(value):
                    // TODO: instantiate dependence value
                    macro null;
            }
            
            result.push(expr);
        }
        return result;
    }
    
    // ==============================================================
    // newtype
    // ==============================================================
    private function createNewtypeExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr 
	{
		var callExpr = createProcessCallExpr((macro context), parameters, destType);
		var instantiationExpr = createClassInstantiationExpr((macro context), [], [(macro data)], sourcePath, parameters);
		
		return macro {
			return switch ($callExpr)
			{
				case litll.core.ds.Result.Ok(data):
					$instantiationExpr;
					
				case litll.core.ds.Result.Err(error):
					litll.core.ds.Result.Err(error);
			}
		}
	}
    
    // ==============================================================
    // tuple
    // ==============================================================
    private function createTupleExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, elements:Array<TupleElement>):Expr 
	{
        var instantiationElements = createTupleInstantiationElements(parameters, elements);
		var instantiationExpr = createClassInstantiationExpr((macro context), instantiationElements.declarations, instantiationElements.references, sourcePath, parameters);
        
        return macro {
            return switch (context.litll)
            {
                case litll.core.Litll.Str(string):
                    litll.core.ds.Result.Err(
                        litll.idl.delitllfy.DelitllfyError.ofLitll(
                            context.litll,
                            litll.idl.delitllfy.DelitllfyErrorKind.CantBeString
                        )
                    );
                    
                case litll.core.Litll.Arr(array):
                    var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(array, 0, context.config);
                    var data = $instantiationExpr;
                    switch (arrayContext.closeOrError())
                    {
                        case haxe.ds.Option.None:
                            data;
                            
                        case haxe.ds.Option.Some(error):
                            litll.core.ds.Result.Err(error);
                    }
            }
		}
	}
    
    private function createTupleInstantiationElements(parameters:TypeParameterDeclarationCollection, elements:Array<TupleElement>):{ declarations:Array<Expr>, references:Array<Expr> }
    {
        var declarations = [];
        var references = [];
        
        for (argument in elements)
        {
            switch (argument)
            {
                case TupleElement.Argument(data):
                    var processFunc = createProcessFuncExpr(parameters, data.type.generalize());
                    
                    var expr = switch [data.name.kind, data.defaultValue]
                    {
                        case [ArgumentKind.Normal, Option.Some(value)]:
                            createGetOrReturnExpr(macro arrayContext.readWithDefault($processFunc, null));
                            
                        case [ArgumentKind.Normal, Option.None]:
                            createGetOrReturnExpr(macro arrayContext.read($processFunc));
                            
                        case [ArgumentKind.Rest, Option.None]:
                            createGetOrReturnExpr(macro arrayContext.readRest($processFunc)); 
                            
                        case [ArgumentKind.Optional, Option.None]:
                            createGetOrReturnExpr(macro arrayContext.readOptional($processFunc)); 
                            
                        case [ArgumentKind.Unfold, Option.None]:
                            // TODO:
                            macro null;
                            
                        case [ArgumentKind.Rest, Option.Some(_)] 
                            | [ArgumentKind.Unfold, Option.Some(_)]
                            | [ArgumentKind.Optional, Option.Some(_)]:
                            throw new IdlException("unsupported default value kind: " + data.name.kind);
                    }
                    
                    var name = "arg" + references.length;
                    declarations.push(macro var $name = $expr);
                    references.push(macro $i{name});
                    
                case TupleElement.Label(data):
                    var value = getStringConstExpr(data.data);
                    declarations.push(macro arrayContext.readLabel($value));
            }
        }
        
        return {
            declarations : declarations,
            references : references
        }
    }
    
    private static function createGetOrReturnExpr(expr:Expr):Expr
    {
        return macro switch ($expr)
        {
            case litll.core.ds.Result.Ok(data): data;
            case litll.core.ds.Result.Err(error): return litll.core.ds.Result.Err(error);
        }
    }
    
    // ==============================================================
    // enum
    // ==============================================================
    private function createEnumExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, constructors:Array<EnumConstructor>):Expr 
	{
        var targetList:Array<Expr> = [];
        var cases:Array<Case> = [];
        
        inline function addTarget(string:String):Void
        {
            targetList.push(
                {
                    expr: ExprDef.EConst(Constant.CString(string)),
                    pos: null,
                }
            );
        }
        inline function _addTupleCase(instantiationExpr:Expr, elements:Array<TupleElement>):Void
        {
            var guard = createTupleGuardConditions(elements, parameters.parameters);
            var caseExpr = macro  {
                var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(array, 0, context.config);
                var data = $instantiationExpr;
                switch (arrayContext.closeOrError())
                {
                    case haxe.ds.Option.None:
                        data;
                        
                    case haxe.ds.Option.Some(error):
                        litll.core.ds.Result.Err(error);
                }
            }
            
            cases.push(createTupleCase(guard, caseExpr));
        }
        inline function addTupleCase(name:EnumConstructorName, elements:Array<TupleElement>):Void
        {
            var string = name.name;
            addTarget(string);
            
            var instantiationElements = createTupleInstantiationElements(parameters, elements);
            var instantiationExpr = createEnumInstantiationExpr(instantiationElements.declarations, instantiationElements.references, sourcePath, name, parameters);
            _addTupleCase(instantiationExpr, elements);
        }
        inline function _addPrimitiveCase(instantiationExpr:Expr, label:String):Void
        {
            var stringExpr:Expr = {
                expr: ExprDef.EConst(Constant.CString(label)),
                pos: null,
            };
            cases.push(
                {
                    values: [macro litll.core.Litll.Str(data)],
                    guard: (macro data.data == $stringExpr),
                    expr: instantiationExpr,
                }
            );
        }
        inline function addPrimitiveCase(name:EnumConstructorName, label:String):Void
        {
            var string = name.name;
            addTarget(string);
            
            var instantiationExpr = createEnumInstantiationExpr([], [], sourcePath, name, parameters);
            _addPrimitiveCase(instantiationExpr, label);
        }
        function _addUnfoldCase(instantiationExpr:Expr, type:TypeReference):Void
        {
            createUnfoldFieldCase(type, parameters.parameters, instantiationExpr, cases);
        }
        
        inline function addUnfoldCase(name:EnumConstructorName, type:TypeReference):Void
        {
            var callExpr = createProcessCallExpr((macro context), parameters, type.generalize());
            var instantiationExpr = createEnumInstantiationExpr(
                [], 
                [createGetOrReturnExpr(callExpr)], 
                sourcePath, name, parameters
            );
            _addUnfoldCase(instantiationExpr, type);
        }
        
        for (constructor in constructors)
        {
            switch (constructor)
            {
                case EnumConstructor.Primitive(name):
                    switch (name.kind)
                    {
                        case EnumConstructorKind.Normal:
                            addPrimitiveCase(name, name.name);
                    
                        case EnumConstructorKind.Tuple:
                            throw new IdlException("tuple is not allowed for primitive enum constructor");
                            
                        case EnumConstructorKind.Unfold:
                            throw new IdlException("unfold is not allowed for primitive enum constructor");
                    }
                    
                case EnumConstructor.Parameterized(parameterized):
                    var elements = parameterized.elements;
                    var name = parameterized.name;
                    switch (parameterized.name.kind)
                    {
                        case EnumConstructorKind.Normal:
                            var label = TupleElement.Label(new LitllString(name.name, name.tag));
                            addTupleCase(name, [label].concat(elements));
                    
                        case EnumConstructorKind.Tuple:
                            addTupleCase(name, elements);
                            
                        case EnumConstructorKind.Unfold:
                            if (elements.length != 1)
                            {
                                throw new IdlException("unfold target type number must be one. but actual " + elements.length);
                            }
                            
                            switch (elements[0])
                            {
                                case TupleElement.Argument(argument):
                                    addUnfoldCase(name, argument.type);
                                    
                                case TupleElement.Label(litllString):
                                    addPrimitiveCase(name, litllString.data);
                            }
                    }
            }
        }
        
        cases.push(
            {
                // case data:
                values : [macro data],
                expr: macro litll.core.ds.Result.Err(
                    litll.idl.delitllfy.DelitllfyError.ofLitll(
                        context.litll, 
                        litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor([$a{targetList}])
                    )
                )
            }
        );
        
        var switchExpr = {
            expr: ExprDef.ESwitch(
                macro context.litll,
                cases,
                null
            ),
            pos: null
        };
         
        return macro return $switchExpr;
	}
    
    
    // ==============================================================
    // struct
    // ==============================================================
    private function createStructExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, elements:Array<StructElement>):Expr 
	{
        var instantiationElements = createStructInstantiationElements(sourcePath, parameters, elements);
        var instantiationExpr = createClassInstantiationExpr((macro context), instantiationElements.declarations, instantiationElements.references, sourcePath, parameters);
        
        return macro return switch (context.litll)
        {
            case litll.core.Litll.Str(string):
                litll.core.ds.Result.Err(
                    litll.idl.delitllfy.DelitllfyError.ofLitll(
                        context.litll,
                        litll.idl.delitllfy.DelitllfyErrorKind.CantBeString
                    )
                );
                
            case litll.core.Litll.Arr(array):
                $instantiationExpr;
        }
    }
    private function createStructInstantiationElements(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, elements:Array<StructElement>):{ declarations:Array<Expr>, references:Array<Expr> }
    {
        var declarations:Array<Expr> = [];
        var references:Array<Expr> = [];
        var cases:Array<Case> = [];
        
        for (element in elements)
        {
            var id = "arg" + references.length;
            
            inline function addOptionDeclaration(instantationExpr:Expr, name:String):Expr
            {
                declarations.push(macro var $id = haxe.ds.Option.None);
                var nameExpr = getStringConstExpr(name);
                
                return macro switch ($i{id})
                {
                    case haxe.ds.Option.Some(data):
                        return litll.core.ds.Result.Err(
                            litll.idl.delitllfy.DelitllfyError.ofLitll(
                                litll,
                                litll.idl.delitllfy.DelitllfyErrorKind.StructElementDupplicated(name)
                            )
                        );
                        
                    case haxe.ds.Option.None:
                        $i{id} = $instantationExpr;
                }
            }
            inline function addArrayDeclaration(instantationExpr:Expr):Expr
            {
                declarations.push(macro var $id = []);
                return macro $i{id}.push($instantationExpr);
            }
            
            switch (element)
            {
                case StructElement.Field(field):
                    inline function fieldInstantiation():Expr
                    {
                        return macro null;
                    }
                    inline function unfoldInstantiation():Expr
                    {
                        var callExpr = createProcessCallExpr((macro context), parameters, field.type.generalize());
                        return callExpr;
                    }
                    inline function addFieldCase(caseExpr:Expr):Void
                    {
                        cases.push(createFieldCase(field.name, field.type, parameters.parameters, caseExpr));
                    }
                    inline function addUnfoldCase(caseExpr:Expr):Void
                    {
                        createUnfoldFieldCase(field.type, parameters.parameters, caseExpr, cases);
                    }
                    
                    switch [field.name.kind, field.defaultValue]
                    {
                        case [StructFieldKind.Normal, Option.None]:
                            var instantationExpr = fieldInstantiation();
                            var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                            addFieldCase(caseExpr);
                            
                        case [StructFieldKind.Normal, Option.Some(defaultValue)]:
                            var instantationExpr = fieldInstantiation();
                            var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                            addFieldCase(caseExpr);
                            
                        case [StructFieldKind.Optional, Option.None]:
                            var instantationExpr = fieldInstantiation();
                            var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                            addFieldCase(caseExpr);
                            
                        case [StructFieldKind.Array, Option.None]:
                            var instantationExpr = fieldInstantiation();
                            var caseExpr = addArrayDeclaration(instantationExpr);
                            addFieldCase(caseExpr);
                            
                        case [StructFieldKind.Unfold, Option.None]:
                            var instantationExpr = unfoldInstantiation();
                            var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                            addUnfoldCase(caseExpr);
                            
                        case [StructFieldKind.Unfold, Option.Some(defaultValue)]:
                            var instantationExpr = unfoldInstantiation();
                            var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                            addUnfoldCase(caseExpr);
                            
                        case [StructFieldKind.OptionalUnfold, Option.None]:
                            var instantationExpr = unfoldInstantiation();
                            var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                            addUnfoldCase(caseExpr);
                            
                        case [StructFieldKind.ArrayUnfold, Option.None]:
                            var instantationExpr = unfoldInstantiation();
                            var caseExpr = addArrayDeclaration(instantationExpr);
                            addUnfoldCase(caseExpr);
                            
                        case [StructFieldKind.Merge, Option.None]:
                            // TODO
                            
                        case [StructFieldKind.ArrayUnfold, Option.Some(_)]
                            | [StructFieldKind.OptionalUnfold, Option.Some(_)]
                            | [StructFieldKind.Array, Option.Some(_)]
                            | [StructFieldKind.Optional, Option.Some(_)]
                            | [StructFieldKind.Merge, Option.Some(_)]:
                            
                            throw new IdlException("unsupported default value kind: " + field.name.kind);
                    }
                    
                    references.push(macro $i{id});
                    
                case StructElement.Label(name) | StructElement.NestedLabel(name):
                    switch (name.kind)
                    {
                        case StructFieldKind.Normal:
                            declarations.push(macro var $id = haxe.ds.Option.None);
                            
                        case StructFieldKind.Array:
                            declarations.push(macro var $id = []);
                            references.push(macro $i{id});
                            
                        case StructFieldKind.Optional:
                            declarations.push(macro var $id = haxe.ds.Option.None);
                            references.push(macro $i{id});
                            
                        case StructFieldKind.Unfold:
                            throw new IdlException("unfold suffix(<) for label is not supported");
                            
                        case StructFieldKind.ArrayUnfold:
                            throw new IdlException("array unfold suffix(<..) for label is not supported");
                            
                        case StructFieldKind.OptionalUnfold:
                            throw new IdlException("optional unfold suffix(<?) for label is not supported");
                            
                        case StructFieldKind.Merge:
                            throw new IdlException("merge suffix(<<) for label is not supported");
                    }
            }
            
        }
        
        cases.push(
            {
                // case data:
                values : [macro litll],
                expr: macro return litll.core.ds.Result.Err(
                    litll.idl.delitllfy.DelitllfyError.ofLitll(
                        litll, 
                        
                        // TODO: target list
                        litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedStructElement([])
                    )
                )
            }
        );
        var switchExpr = {
            expr: ExprDef.ESwitch(
                macro litll,
                cases,
                null
            ),
            pos: null
        }
        declarations.push(
            macro for (litll in array.data)
            {
                var context = new DelitllfyContext(litll, context.config);
                $switchExpr;
            }
        );
        
        return {
            declarations: declarations,
            references: references,
        }
    }
    
    // ==============================================================
    // guard
    // ==============================================================
    private function createTupleGuardConditions(elements:Array<TupleElement>, definitionParameters:Array<TypeName>):DelitllfyGuardCondition
    {
        return DelitllfyGuardCondition.createForTuple(elements, context.source, definitionParameters);
    }
    private function createFieldGuardConditions(name:StructFieldName, type:TypeReference, definitionParameters:Array<TypeName>):DelitllfyGuardCondition
    {
        return createTupleGuardConditions(
            [
                TupleElement.Label(new LitllString(name.name, name.tag)),
                TupleElement.Argument(
                    new Argument(
                        new ArgumentName(name.name, name.tag),
                        type,
                        Option.None
                    )
                )
            ],
            definitionParameters
        );
    }
    
    // ==============================================================
    // case
    // ==============================================================
    private function createFieldCase(name:StructFieldName, type:TypeReference, definitionParameters:Array<TypeName>, caseExpr:Expr):Case
    {
        var guard = createTupleGuardConditions(
            [
                TupleElement.Label(new LitllString(name.name, name.tag)),
                TupleElement.Argument(
                    new Argument(
                        new ArgumentName(name.name, name.tag),
                        type,
                        Option.None
                    )
                )
            ],
            definitionParameters
        );
        
        return createTupleCase(guard, caseExpr);
    }
    private function createUnfoldFieldCase(type:TypeReference, definitionParameters:Array<TypeName>, caseExpr:Expr, outputCases:Array<Case>):Void
    {
        var unfoldedType = type.unfold(context.source, definitionParameters);
        for (caseKind in DelitllfyCaseConditionTools.createForUnfoldedType(unfoldedType, context.source))
        {
            var caseData = switch (caseKind)
            {
                case DelitllfyCaseCondition.Arr(guard):
                    createTupleCase(guard, caseExpr);
                    
                case DelitllfyCaseCondition.Str:
                    {
                        values: [macro litll.core.Litll.Str(_)],
                        expr: caseExpr,
                    }
                    
                case DelitllfyCaseCondition.Const(label):
                    var stringExpr:Expr = getStringConstExpr(label);
                    {
                        values: [macro litll.core.Litll.Str(str)],
                        guard: (macro str.data == $stringExpr),
                        expr: caseExpr,
                    }
            }
            
            outputCases.push(caseData);
        }
    }
    
    private static function createTupleCase(guard:DelitllfyGuardCondition, caseExpr:Expr):Case
    {
        var guardConditions = guard.getConditionExprs(macro array);
        return {
            values: [macro litll.core.Litll.Arr(array)],
            guard: if (guardConditions.length == 0) null else createAndExpr(guardConditions),
            expr: caseExpr,
        }
    }
    
    private static function createAndExpr(exprs:Array<Expr>):Expr 
    {
        return if (exprs.length == 0)
        {
            macro true;
        }
        else if (exprs.length == 1)
        {
            exprs[0];
        }
        else
        {
            expr: ExprDef.EBinop(Binop.OpBoolAnd, exprs[0], createAndExpr(exprs.slice(1))),
            pos: null
        };
    }
    
    // ==============================================================
    // case
    // ==============================================================
    private static function getStringConstExpr(label:String):Expr
    {
        return {
            expr: ExprDef.EConst(Constant.CString(label)),
            pos: null,
        };
    }
}
