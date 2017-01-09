package litll.idl.project.output.delitll;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
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
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
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
				
			case IdlTypeDefinition.Union(name, constructors):
				parameters = name.getParameters().collect();
				macro null;
                
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
    private function createClassInstantiationExpr(contextExpr:Expr, instantiationArgments:Array<Expr>, sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection):Expr
    {
        var classInterface = context.interfaceStore.getDataClassInterface(sourcePath).getOrThrow(IdlException.new.bind("class " + sourcePath.toString() + " not found"));
        for (dependance in parameters.dependences)
        {
            instantiationArgments.push(macro $i{dependance.name.toVariableName()});
        }
        
        return switch (classInterface.delitllfier)
        {
            case HaxeDataConstructorKind.New:
                var sourceTypePath = sourcePath.toMacroPath();
                macro {
                    var instance = new $sourceTypePath($a{instantiationArgments});
                    litll.core.ds.Result.Ok(instance);
                }
                
            case HaxeDataConstructorKind.Function(name, HaxeDataConstructorReturnKind.Direct):
                macro {
                    var instance = $i{sourcePath.toString()}.$name($a{instantiationArgments});
                    litll.core.ds.Result.Ok(instance);
                }
                
            case HaxeDataConstructorKind.Function(name, HaxeDataConstructorReturnKind.Result):
                macro {
                    switch ($i{sourcePath.toString()}.$name($a{instantiationArgments}))
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
                }
        }
	}
    
    private function createEnumInstantiationExpr(instantiationArgments:Array<Expr>, sourcePath:HaxeDataTypePath, name:EnumConstructorName, parameters:TypeParameterDeclarationCollection):Expr 
    {
        for (dependance in parameters.dependences)
        {
            instantiationArgments.push(macro $i{dependance.name.toVariableName()});
        }
        
        var sourceTypePath = sourcePath.toString();
        var constructorName = name.toPascalCase().getOrThrow();
        
        return if (instantiationArgments.length == 0)
        {
            macro litll.core.ds.Result.Ok($i{sourceTypePath}.$constructorName);
        }
        else
        {
            macro litll.core.ds.Result.Ok($i{sourceTypePath}.$constructorName($a{instantiationArgments}));
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
                    var typeName = type.getName() + "Delitllfier";
                    switch (type)
                    {
                        case TypeReference.Primitive(primitive):
                            macro $i{typeName}.process;
                            
                        case TypeReference.Generic(generic):
                            var childParametersExpr = [macro _].concat(createParmetersExpr(generic.parameters));
                            macro $i{typeName}.process.bind($a{childParametersExpr});
                    }
                    
                case TypeReferenceParameterKind.Dependence(value):
                    // TODO: instantiate dependance value
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
		var instantiationExpr = createClassInstantiationExpr((macro context), [(macro data)], sourcePath, parameters);
		
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
    private function createTupleExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, arguments:Array<Argument>):Expr 
	{
        var instantiationArguments = createTupleInstantiationArguments(parameters, arguments);
		var instantiationExpr = createClassInstantiationExpr((macro context), instantiationArguments, sourcePath, parameters);
        
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
                    
                case litll.core.Litll.Arr(array):
                    try
                    {
                        var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(array, 0, context.config);
                        arrayContext.closeWithResult(function () return $instantiationExpr);
                    }
                    catch (error:litll.idl.delitllfy.DelitllfyError)
                    {
                        litll.core.ds.Result.Err(error);
                    }
            }
		}
	}
    private function createTupleInstantiationArguments(parameters:TypeParameterDeclarationCollection, arguments:Array<Argument>):Array<Expr>
    {
        var result = [];
        for (argument in arguments)
        {
            var processFunc = createProcessFuncExpr(parameters, argument.type.generalize());
            
            // TODO: defatult value
            var expr = switch (argument.name.kind)
            {
                case ArgumentKind.Normal:
                    macro litll.core.ds.ResultTools.getOrThrow(arrayContext.read($processFunc)); 
                    
                case ArgumentKind.Rest:
                    macro litll.core.ds.ResultTools.getOrThrow(arrayContext.readRest($processFunc)); 
                    
                case ArgumentKind.Skippable:
                    // TODO:
                    macro null;
                    
                case ArgumentKind.Structure:
                    // TODO:
                    macro null;
            }
            
            result.push(expr);
        }
        
        return result;
    }
    
    // ==============================================================
    // enum
    // ==============================================================
    private function createEnumExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, constructors:Array<EnumConstructor>):Expr 
	{
        var targetList:Array<Expr> = [];
        var arrayCases:Array<Case> = [];
        var stringCases:Array<Case> = [];
        
        for (constructor in constructors)
        {
            switch (constructor)
            {
                case EnumConstructor.Primitive(name):
                    var string = name.toString();
                    targetList.push(
                        {
                            expr: ExprDef.EConst(Constant.CString(string)),
                            pos: null,
                        }
                    );
                    var instantiationExpr = createEnumInstantiationExpr([], sourcePath, name, parameters);
                    stringCases.push(
                        {
                            values : [
                                {
                                    expr: ExprDef.EConst(Constant.CString(string)),
                                    pos: null,
                                }
                            ],
                            expr: macro $instantiationExpr,
                        }
                    );
                    
                case EnumConstructor.Parameterized(data):
                    var string = data.name.toString();
                    targetList.push(
                        {
                            expr: ExprDef.EConst(Constant.CString("[" + string + "]")),
                            pos: null,
                        }
                    );
                    
                    var instantiationArguments = createTupleInstantiationArguments(parameters, data.arguments);
                    var instantiationExpr = createEnumInstantiationExpr(instantiationArguments, sourcePath, data.name, parameters);
                    arrayCases.push(
                        {
                            values : [
                                {
                                    expr: ExprDef.EConst(Constant.CString(string)),
                                    pos: null,
                                }
                            ],
                            expr: macro  {
                                var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(array, 1, context.config);
                                arrayContext.closeWithResult(function () return $instantiationExpr);
                            }
                        }
                    );
            }
        }
        
        arrayCases.push(
            {
                // case data:
                values : [macro data],
                expr: macro litll.core.ds.Result.Err(
                    litll.idl.delitllfy.DelitllfyError.ofLitll(
                        context.litll, 
                        litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor(data, expected)
                    )
                )
            }
        );
        stringCases.push(
            {
                // case data:
                values : [macro data],
                expr: macro litll.core.ds.Result.Err(
                    litll.idl.delitllfy.DelitllfyError.ofLitll(
                        context.litll, 
                        litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor(data, expected)
                    )
                )
            }
        );
        
        var arraySwitch:Expr = {
            expr: ExprDef.ESwitch(
                macro string.data,
                arrayCases,
                null
            ),
            pos: null
        };
        var stringSwitch:Expr = {
            expr: ExprDef.ESwitch(
                macro string.data,
                stringCases,
                null
            ),
            pos: null
        };
        
        return macro 
        {
            var expected = $a{targetList};
            return switch (context.litll)
            {
                case litll.core.Litll.Arr(array) if (array.data.length > 0):
                    switch (array.data[0])
                    {
                        case litll.core.Litll.Str(string):
                            $arraySwitch;
                            
                        case litll.core.Litll.Arr(_):
                            litll.core.ds.Result.Err(
                                litll.idl.delitllfy.DelitllfyError.ofArray(
                                    array, 
                                    0, 
                                    litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor("[[..]]", expected), 
                                    []
                                )
                            );
                    }
                    
                case litll.core.Litll.Arr(_):
                    litll.core.ds.Result.Err(
                        litll.idl.delitllfy.DelitllfyError.ofLitll(
                            context.litll, 
                            litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor("[]", expected)
                        )
                    );
                    
                case litll.core.Litll.Str(string):
                    $stringSwitch;
            }
        }
	}
}
