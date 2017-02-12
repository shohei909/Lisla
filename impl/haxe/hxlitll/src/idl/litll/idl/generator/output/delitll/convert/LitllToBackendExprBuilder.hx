package litll.idl.generator.output.delitll.convert;
import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Case;
import litll.core.LitllString;
import litll.idl.exception.IdlException;
import litll.idl.generator.data.LitllToBackendOutputConfig;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.data.store.HaxeDataConstructorKind;
import litll.idl.generator.output.data.store.HaxeDataConstructorReturnKind;
import litll.idl.generator.output.data.store.HaxeDataInterface;
import litll.idl.generator.output.data.store.HaxeDataInterfaceKind;
import litll.idl.generator.output.delitll.match.LitllToBackendCaseCondition;
import litll.idl.generator.output.delitll.match.LitllToBackendCaseConditionTools;
import litll.idl.generator.output.delitll.match.LitllToBackendGuardCondition;
import litll.idl.generator.output.delitll.path.HaxeLitllToBackendTypePathPair;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.litll2backend.LitllToBackendError;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.StructElementName;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.error.ArgumentSuffixErrorKindTools;
import litll.idl.std.error.GetConditionErrorKindTools;
import litll.idl.std.tools.idl.FollowedTypeDefinitionTools;
import litll.idl.std.tools.idl.TupleTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;


class LitllToBackendExprBuilder 
{
	public var context(default, null):IdlToHaxeConvertContext;
    private var config:LitllToBackendOutputConfig;
    
	public function new (context:IdlToHaxeConvertContext, config:LitllToBackendOutputConfig)
	{
		this.context = context;
		this.config = config;
	}
    
    // ==============================================================
    // common
    // ==============================================================
    public function createClassInstantiationExpr(contextExpr:Expr, argumentDeclarations:Array<Expr>, argumentReferences:Array<Expr>, dataInterface:HaxeDataInterface, parameters:TypeParameterDeclarationCollection):Expr
    {
        var sourcePath = dataInterface.path;
        var classInterface = switch(dataInterface.kind)
        {
            case HaxeDataInterfaceKind.Class(data):
                data;
                
            case HaxeDataInterfaceKind.Enum(_):
                throw new IdlException("must be class interface");
        }
        
        for (dependence in parameters.dependences)
        {
            argumentReferences.push(macro $i{dependence.name.toVariableName()});
        }
        
        return switch (classInterface.litllToBackend)
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
                            case litll.core.ds.Result.Ok(data):
                                litll.core.ds.Result.Ok(data);
                                
                            case litll.core.ds.Result.Err(data):
                                litll.core.ds.Result.Err(
                                    litll.idl.litll2backend.LitllToBackendError.ofLitll(
                                        $contextExpr.litll, 
                                        data
                                    )
                                );
                        }
                    ]
                );
                macro { $a{blockBody} }
        }
	}
    
    public function createEnumInstantiationExpr(argumentDeclaration:Array<Expr>, argumentReferences:Array<Expr>, sourcePath:HaxeDataTypePath, name:EnumConstructorName, parameters:TypeParameterDeclarationCollection):Expr 
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
	public function createProcessCallExpr(contextExpr:Expr, parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
	{
        return createCallExpr("process", contextExpr, parameters, destType);
    }
	private function createCallExpr(functionName:String, contextExpr:Expr, parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
    {
        var funcName = createProcessFuncNameExpr(functionName, parameters, destType);
        var processElements = [contextExpr].concat(createParmetersExpr(parameters, destType));
        return macro $funcName($a{processElements});
    }
	public function createProcessFuncExpr(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
	{
        return createFuncExpr("process", parameters, destType);
    }
	public function createFixedInlineProcessFuncExpr(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
	{
        return createFuncExpr("fixedInlineProcess", parameters, destType);
    }
	public function createVariableInlineProcessFuncExpr(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
	{
        return createFuncExpr("variableInlineProcess", parameters, destType);
    }
	private function createFuncExpr(functionName:String, parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
	{
        var funcName = createProcessFuncNameExpr(functionName, parameters, destType);
        var processElements = createParmetersExpr(parameters, destType);
        
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
    private function createProcessFuncNameExpr(functionName:String, parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
    {
        var typeName = createTypeNameExpr(parameters, destType);
        return macro $typeName.$functionName;
    }
    private function createTypeNameExpr(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
    {
        return switch (searchTypeParameter(parameters, destType))
        {
            case Option.Some(typeParameter):
                var typeName = typeParameter.toLitllToBackendVariableName();
                macro $i{typeName};
                
            case Option.None:
                var haxePath = config.toHaxeLitllToBackendPath(destType.typePath);
                macro $i{haxePath.toString()};
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
    private function createParmetersExpr(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Array<Expr>
    {
        var result = [];
        for (parameter in destType.parameters)
        {
            var expr = switch (parameter.processedValue.getOrThrow(IdlException.new.bind("parameter must be processed")))
            {
                case TypeReferenceParameterKind.Type(type):
                    createTypeNameExpr(parameters, type.generalize());
                    
                case TypeReferenceParameterKind.Dependence(_, _):
                    // TODO: instantiate dependence value
                    macro null;
            }
            
            result.push(expr);
        }
        return result;
    }
    
    // ==============================================================
    // guard
    // ==============================================================
    public function createTupleGuardConditions(elements:Array<TupleElement>, definitionParameters:Array<TypeName>):LitllToBackendGuardCondition
    {
        return elements.getGuard(context.source, definitionParameters).getOrThrow(GetConditionErrorKindTools.toIdlException);
    }
    public function createFieldGuardConditions(name:StructElementName, type:TypeReference, definitionParameters:Array<TypeName>):LitllToBackendGuardCondition
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
    public function getFixedLength(elements:Array<TupleElement>, definitionParameters:Array<TypeName>):Option<Int>
    {
        return elements.getFixedLength(context.source, definitionParameters).getOrThrow(GetConditionErrorKindTools.toIdlException);
    }
    public function getInlineFixedLength(argument:Argument, definitionParameters:Array<TypeName>):Option<Int>
    {
        return argument.getFixedLength(context.source, definitionParameters).getOrThrow(GetConditionErrorKindTools.toIdlException);
    }
    
    // ==============================================================
    // case
    // ==============================================================
    public function createFieldCase(name:StructElementName, type:TypeReference, definitionParameters:Array<TypeName>, caseExpr:Expr):Case
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
    public function createTypeCase(type:TypeReference, definitionParameters:Array<TypeName>, caseExpr:Expr, outputCases:Array<Case>):Void
    {
        var followedType = type.followOrThrow(context.source, definitionParameters);
        var conditions = followedType.getConditions(context.source, definitionParameters).getOrThrow(GetConditionErrorKindTools.toIdlException);
        createConditionsCase(conditions, caseExpr, outputCases);
    }
    
    public static function createTupleCase(guard:LitllToBackendGuardCondition, caseExpr:Expr):Case
    {
        var guardConditions = guard.getConditionExprs(macro array);
        return {
            values: [macro litll.core.Litll.Arr(array)],
            guard: if (guardConditions.length == 0) null else ExprBuilder.createAndExpr(guardConditions),
            expr: caseExpr,
        }
    }
    
    public function createFirstTypeCase(argument:Argument, definitionParameters:Array<TypeName>, caseExpr:Expr, outputCases:Array<Case>):Void
    {
        var path = argument.type.getTypePath().toString();
        var followedType = argument.type.followOrThrow(context.source, definitionParameters);
        var conditions = followedType.getNotEmptyFirstElementCondition(
            argument.name, 
            context.source, 
            definitionParameters, 
            [path],
            []
        ).getOrThrow(GetConditionErrorKindTools.toIdlException);
        
        createConditionsCase(conditions, caseExpr, outputCases);
    }
    
    private function createConditionsCase(conditions:Array<LitllToBackendCaseCondition>, caseExpr:Expr, outputCases:Array<Case>):Void
    {
        for (condition in conditions)
        {
            var caseData = switch (condition)
            {
                case LitllToBackendCaseCondition.Arr(guard):
                    createTupleCase(guard, caseExpr);
                    
                case LitllToBackendCaseCondition.Str:
                    {
                        values: [macro litll.core.Litll.Str(_)],
                        expr: caseExpr,
                    }
                    
                case LitllToBackendCaseCondition.Const(label):
                    var stringExpr:Expr = ExprBuilder.getStringConstExpr(label);
                    {
                        values: [macro litll.core.Litll.Str(string)],
                        guard: (macro string.data == $stringExpr),
                        expr: caseExpr,
                    }
            }
            
            outputCases.push(caseData);
        }
    }
}
