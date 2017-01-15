package litll.idl.project.output.delitll;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.exception.IdlException;
import litll.idl.project.output.data.HaxeDataTypePath;
import litll.idl.project.output.data.store.HaxeDataConstructorKind;
import litll.idl.project.output.data.store.HaxeDataConstructorReturnKind;
import litll.idl.project.output.delitll.HaxeDelitllfierTypePathPair;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentName.ArgumentKind;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorCondition;
import litll.idl.std.data.idl.EnumConstructorHeader;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.TupleArgument;
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
				
			case IdlTypeDefinition.Tuple(name, arguments):
				parameters = name.getParameters().collect();
				createTupleExpr(pathPair.dataPath, parameters, arguments);
                
			case IdlTypeDefinition.Enum(name, constructors):
				parameters = name.getParameters().collect();
                createEnumExpr(pathPair.dataPath, parameters, constructors);
				
			case IdlTypeDefinition.Struct(name, arguments):
				parameters = name.getParameters().collect();
				macro null;
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
        var processArguments = [contextExpr].concat(createParmetersExpr(destType.parameters));
        return macro $funcName($a{processArguments});
    }
	private function createProcessFuncExpr(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
	{
        var funcName = createProcessFuncNameExpr(parameters, destType);
        var processArguments = createParmetersExpr(destType.parameters);
        
        return if (processArguments.length == 0)
        {
            macro $funcName;
        }
        else
        {
            var args = [macro _].concat(processArguments);
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
                            
                        case TypeReference.Generic(typePath, parameters):
                            var childParametersExpr = [macro _].concat(createParmetersExpr(parameters));
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
    private function createTupleExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, arguments:Array<TupleArgument>):Expr 
	{
        var instantiationArguments = createTupleInstantiationArguments(parameters, arguments);
		var instantiationExpr = createClassInstantiationExpr((macro context), instantiationArguments.declarations, instantiationArguments.references, sourcePath, parameters);
        
        return macro {
            return switch (context.litll)
            {
                case litll.core.Litll.Str(string):
                    litll.core.ds.Result.Err(
                        litll.idl.delitllfy.DelitllfyError.ofString(
                            string, 
                            litll.core.ds.Maybe.none(), 
                            litll.idl.delitllfy.DelitllfyErrorKind.CantBeString
                        )
                    );
                    
                case litll.core.Litll.Arr(data):
                    try
                    {
                        var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
                        arrayContext.closeWithResult(function () return $instantiationExpr);
                    }
                    catch (error:litll.idl.delitllfy.DelitllfyError)
                    {
                        litll.core.ds.Result.Err(error);
                    }
            }
		}
	}
    
    private function createTupleInstantiationArguments(parameters:TypeParameterDeclarationCollection, arguments:Array<TupleArgument>):{ declarations:Array<Expr>, references:Array<Expr> }
    {
        var declarations = [];
        var references = [];
        
        for (argument in arguments)
        {
            switch (argument)
            {
                case TupleArgument.Data(data):
                    var processFunc = createProcessFuncExpr(parameters, data.type.generalize());
                    
                    // TODO: defatult value
                    var expr = switch (data.name.kind)
                    {
                        case ArgumentKind.Normal:
                            macro litll.core.ds.ResultTools.getOrThrow(arrayContext.read($processFunc)); 
                            
                        case ArgumentKind.Rest:
                            macro litll.core.ds.ResultTools.getOrThrow(arrayContext.readRest($processFunc)); 
                            
                        case ArgumentKind.Skippable:
                            // TODO:
                            macro null;
                            
                        case ArgumentKind.Unfold:
                            // TODO:
                            macro null;
                    }
                    
                    var name = "arg" + references.length;
                    declarations.push(macro var $name = $expr);
                    references.push(macro $i{name});
                    
                case TupleArgument.Label(data):
                    var value = {
                        expr: ExprDef.EConst(Constant.CString(data.data)),
                        pos: null,
                    }
                    declarations.push(macro arrayContext.readLabel($value));
            }
        }
        
        return {
            declarations : declarations,
            references : references
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
        inline function _addTupleCase(instantiationExpr:Expr, arguments:Array<TupleArgument>):Void
        {
            var guardConditions = createGuardConditions(arguments);
            var caseData = {
                values: [macro litll.core.Litll.Arr(data)],
                guard: if (guardConditions.length == 0) null else createOrExpr(guardConditions),
                expr: macro  {
                    var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
                    arrayContext.closeWithResult(function () return $instantiationExpr);
                }
            };
            
            cases.push(caseData);
        }
        inline function addTupleCase(name:EnumConstructorName, arguments:Array<TupleArgument>):Void
        {
            var string = name.toString();
            addTarget(string);
            
            var instantiationArguments = createTupleInstantiationArguments(parameters, arguments);
            var instantiationExpr = createEnumInstantiationExpr(instantiationArguments.declarations, instantiationArguments.references, sourcePath, name, parameters);
            _addTupleCase(instantiationExpr, arguments);
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
            var string = name.toString();
            addTarget(string);
            
            var instantiationExpr = createEnumInstantiationExpr([], [], sourcePath, name, parameters);
            _addPrimitiveCase(instantiationExpr, label);
        }
        function _addUnfoldCase(instantiationExpr:Expr, type:TypeReference):Void
        {
            switch (type.unfold(context.source))
            {
                case UnfoldedTypeDefinition.Arr(_):
                    cases.push(
                        {
                            values: [macro litll.core.Litll.Arr(_)],
                            expr: instantiationExpr,
                        }
                    );
                    
                case UnfoldedTypeDefinition.Str:
                    cases.push(
                        {
                            values: [macro litll.core.Litll.Str(_)],
                            expr: instantiationExpr,
                        }
                    );
                    
                case UnfoldedTypeDefinition.Tuple(arguments):
                    _addTupleCase(instantiationExpr, arguments);
                    
                case UnfoldedTypeDefinition.Enum(constructors):
                    for (constructor in constructors)
                    {
                        switch (constructor)
                        {
                            case EnumConstructor.Primitive(name):
                                _addPrimitiveCase(instantiationExpr, name.toString());
                                
                            case EnumConstructor.Parameterized(EnumConstructorHeader.Basic(name), arguments):
                                var label = TupleArgument.Label(new LitllString(name.toString(), name.tag));
                                _addTupleCase(instantiationExpr, [label].concat(arguments));
                                
                            case EnumConstructor.Parameterized(EnumConstructorHeader.Special(name, EnumConstructorCondition.Tuple), arguments):
                                _addTupleCase(instantiationExpr, arguments);
                                
                            case EnumConstructor.Parameterized(EnumConstructorHeader.Special(name, EnumConstructorCondition.Unfold), arguments):
                                if (arguments.length != 1)
                                {
                                    throw new IdlException("unfold target type number must be one. but actual " + arguments.length);
                                }
                                
                                switch (arguments[0])
                                {
                                    case TupleArgument.Data(argument):
                                        _addUnfoldCase(instantiationExpr, argument.type);
                                        
                                    case TupleArgument.Label(litllString):
                                        _addPrimitiveCase(instantiationExpr, litllString.data);
                                }
                        }
                    }
                    
                case UnfoldedTypeDefinition.Struct(_):
                    throw new IdlException("struct " + sourcePath.toString() + " can't be unfold");
            }
        }
        inline function addUnfoldCase(name:EnumConstructorName, type:TypeReference):Void
        {
            var callExpr = createProcessCallExpr((macro context), parameters, type.generalize());
            var instantiationExpr = createEnumInstantiationExpr(
                [], 
                [macro litll.core.ds.ResultTools.getOrThrow($callExpr)], 
                sourcePath, name, parameters
            );
            _addUnfoldCase(instantiationExpr, type);
        }
        
        for (constructor in constructors)
        {
            switch (constructor)
            {
                case EnumConstructor.Primitive(name):
                    addPrimitiveCase(name, name.toString());
                    
                case EnumConstructor.Parameterized(EnumConstructorHeader.Basic(name), arguments):
                    var label = TupleArgument.Label(new LitllString(name.toString(), name.tag));
                    addTupleCase(name, [label].concat(arguments));
                    
                case EnumConstructor.Parameterized(EnumConstructorHeader.Special(name, EnumConstructorCondition.Tuple), arguments):
                    addTupleCase(name, arguments);
                    
                case EnumConstructor.Parameterized(EnumConstructorHeader.Special(name, EnumConstructorCondition.Unfold), arguments):
                    if (arguments.length != 1)
                    {
                        throw new IdlException("unfold target type number must be one. but actual " + arguments.length);
                    }
                    
                    switch (arguments[0])
                    {
                        case TupleArgument.Data(argument):
                            addUnfoldCase(name, argument.type);
                            
                        case TupleArgument.Label(litllString):
                            addPrimitiveCase(name, litllString.data);
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
    
    private function createGuardConditions(arguments:Array<TupleArgument>):Array<Expr>
    {
        var result = [];
        var min:Int = 0;
        var more:Bool = false;
        
        for (argument in arguments)
        {
            switch (argument)
            {
                case TupleArgument.Label(value):
                    if (!more)
                    {
                        var string = {
                            expr: ExprDef.EConst(Constant.CString(value.data)),
                            pos: null,
                        }
                        var index = {
                            expr: ExprDef.EConst(Constant.CInt(Std.string(min))),
                            pos: null,
                        }
                        result.push(macro data.data[$index].match(litll.core.Litll.Str(_.data => $string)));
                    }
                    min++;
                    
                case TupleArgument.Data(argument):
                    switch (argument.name.kind)
                    {
                        case ArgumentKind.Normal:
                            min++;
                            
                        case ArgumentKind.Rest | ArgumentKind.Skippable:
                            more = true;
                            
                        case ArgumentKind.Unfold:
                            argument.type;
                    }
            }
        }
        
        var value = {
            expr: ExprDef.EConst(Constant.CInt(Std.string(min))),
            pos: null,
        }
        if (more)
        {
            result.unshift(macro data.length >= $value);
        }
        else
        {
            result.unshift(macro data.length == $value);
        }
        
        return result;
    }
    
    private static function createOrExpr(exprs:Array<Expr>):Expr 
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
            expr: ExprDef.EBinop(Binop.OpBoolOr, exprs[0], createOrExpr(exprs.slice(1))),
            pos: null
        };
    }
}
