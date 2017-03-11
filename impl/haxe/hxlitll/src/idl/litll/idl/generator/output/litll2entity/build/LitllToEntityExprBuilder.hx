package lisla.idl.generator.output.lisla2entity.build;
import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Case;
import hxext.ds.Result;
import lisla.core.LislaString;
import lisla.idl.exception.IdlException;
import lisla.idl.generator.data.LislaToEntityOutputConfig;
import lisla.idl.generator.output.entity.EntityHaxeTypePath;
import lisla.idl.generator.output.entity.store.HaxeEntityConstructorKind;
import lisla.idl.generator.output.entity.store.HaxeEntityConstructorReturnKind;
import lisla.idl.generator.output.entity.store.HaxeEntityInterface;
import lisla.idl.generator.output.entity.store.HaxeEntityInterfaceKind;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseCondition;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseConditionTools;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardCondition;
import lisla.idl.generator.output.lisla2entity.path.HaxeLislaToEntityTypePathPair;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.generator.source.validate.ValidType;
import lisla.idl.generator.tools.ExprBuilder;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.std.entity.idl.Argument;
import lisla.idl.std.entity.idl.ArgumentName;
import lisla.idl.std.entity.idl.EnumConstructorName;
import lisla.idl.std.entity.idl.GenericTypeReference;
import lisla.idl.std.entity.idl.StructElementName;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.entity.idl.TypeReference;
import lisla.idl.std.entity.idl.TypeReferenceParameter;
import lisla.idl.std.entity.idl.TypeReferenceParameterKind;
import lisla.idl.std.error.ArgumentSuffixErrorKindTools;
import lisla.idl.std.error.GetConditionErrorKindTools;
import lisla.idl.std.tools.idl.FollowedTypeDefinitionTools;
import lisla.idl.std.tools.idl.TupleTools;
import lisla.idl.std.tools.idl.TypeParameterDeclarationCollection;


class LislaToEntityExprBuilder
{
	public var context(default, null):HaxeConvertContext;
    
	public function new (context:HaxeConvertContext)
	{
		this.context = context;
    }
    
    // ==============================================================
    // common
    // ==============================================================
    public function createClassInstantiationExpr(contextExpr:Expr, argumentDeclarations:Array<Expr>, argumentReferences:Array<Expr>, dataInterface:HaxeEntityInterface, parameters:TypeParameterDeclarationCollection):Expr
    {
        var sourcePath = dataInterface.path;
        var classInterface = switch(dataInterface.kind)
        {
            case HaxeEntityInterfaceKind.Class(data):
                data;
                
            case HaxeEntityInterfaceKind.Enum(_):
                throw new IdlException("must be class interface");
        }
        
        for (dependence in parameters.dependences)
        {
            argumentReferences.push(macro $i{dependence.name.toVariableName()});
        }
        
        return switch (classInterface.lislaToEntity)
        {
            case HaxeEntityConstructorKind.New:
                var sourceTypePath = sourcePath.toMacroPath();
                var blockBody = argumentDeclarations.concat(
                    [
                        (macro var instance = new $sourceTypePath($a{argumentReferences})),
                        (macro hxext.ds.Result.Ok(instance)),
                    ]
                );
                macro { $a{blockBody} }
                
            case HaxeEntityConstructorKind.Function(name, HaxeEntityConstructorReturnKind.Direct):
                var blockBody = argumentDeclarations.concat(
                    [
                        (macro var instance = $i{sourcePath.toString()}.$name($a{argumentReferences})),
                        (macro hxext.ds.Result.Ok(instance)),
                    ]
                );
                macro { $a{blockBody} }
                
            case HaxeEntityConstructorKind.Function(name, HaxeEntityConstructorReturnKind.Result):
                var blockBody = argumentDeclarations.concat(
                    [
                        macro switch ($i{sourcePath.toString()}.$name($a{argumentReferences}))
                        {
                            case hxext.ds.Result.Ok(data):
                                hxext.ds.Result.Ok(data);
                                
                            case hxext.ds.Result.Err(data):
                                hxext.ds.Result.Err(
                                    lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(
                                        $contextExpr.lisla, 
                                        data
                                    )
                                );
                        }
                    ]
                );
                macro { $a{blockBody} }
        }
	}
    
    public function createEnumInstantiationExpr(argumentDeclaration:Array<Expr>, argumentReferences:Array<Expr>, sourcePath:EntityHaxeTypePath, name:EnumConstructorName, parameters:TypeParameterDeclarationCollection):Expr 
    {
        for (dependence in parameters.dependences)
        {
            argumentReferences.push(macro $i{dependence.name.toVariableName()});
        }
        
        var sourceTypePath = sourcePath.toString();
        var constructorName = name.toPascalCase().getOrThrow();
        
        return if (argumentReferences.length == 0)
        {
            macro hxext.ds.Result.Ok($i{sourceTypePath}.$constructorName);
        }
        else
        {
            var blockBody = argumentDeclaration.concat(
                [
                    (macro hxext.ds.Result.Ok($i{sourceTypePath}.$constructorName($a{argumentReferences})))
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
                var typeName = typeParameter.toLislaToEntityVariableName();
                macro $i{typeName};
                
            case Option.None:
                var haxePath = context.lislaToEntityConfig.toHaxeLislaToEntityPath(destType.typePath);
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
    public function createTupleGuardConditions(elements:Array<TupleElement>, definitionParameters:Array<TypeName>):LislaToEntityGuardCondition
    {
        return elements.getGuard(context, definitionParameters).getOrThrow(GetConditionErrorKindTools.toIdlException);
    }
    public function createFieldGuardConditions(name:StructElementName, type:TypeReference, definitionParameters:Array<TypeName>):LislaToEntityGuardCondition
    {
        return createTupleGuardConditions(
            [
                TupleElement.Label(new LislaString(name.name, name.tag)),
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
        return elements.getFixedLength(context, definitionParameters).getOrThrow(GetConditionErrorKindTools.toIdlException);
    }
    public function getInlineFixedLength(argument:Argument, definitionParameters:Array<TypeName>):Option<Int>
    {
        return argument.getFixedLength(context, definitionParameters).getOrThrow(GetConditionErrorKindTools.toIdlException);
    }
    
    // ==============================================================
    // case
    // ==============================================================
    public function createFieldCase(name:StructElementName, type:TypeReference, definitionParameters:Array<TypeName>, caseExpr:Expr):Case
    {
        var guard = createTupleGuardConditions(
            [
                TupleElement.Label(new LislaString(name.name, name.tag)),
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
        var followedType = type.followOrThrow(context, definitionParameters);
        var conditions = followedType.getConditions(context, definitionParameters).getOrThrow(GetConditionErrorKindTools.toIdlException);
        createConditionsCase(conditions, caseExpr, outputCases);
    }
    
    public static function createTupleCase(guard:LislaToEntityGuardCondition, caseExpr:Expr):Case
    {
        var guardConditions = guard.getConditionExprs(macro array);
        return {
            values: [macro lisla.core.Lisla.Arr(array)],
            guard: if (guardConditions.length == 0) null else ExprBuilder.createAndExpr(guardConditions),
            expr: caseExpr,
        }
    }
    
    public function createFirstTypeCase(argument:Argument, definitionParameters:Array<TypeName>, caseExpr:Expr, outputCases:Array<Case>):Void
    {
        var path = argument.type.getTypePath().toString();
        var followedType = argument.type.followOrThrow(context, definitionParameters);
        var conditions = followedType.getNotEmptyFirstElementCondition(
            argument.name, 
            context, 
            definitionParameters, 
            [path],
            []
        ).getOrThrow(GetConditionErrorKindTools.toIdlException);
        
        createConditionsCase(conditions, caseExpr, outputCases);
    }
    
    private function createConditionsCase(conditions:Array<LislaToEntityCaseCondition>, caseExpr:Expr, outputCases:Array<Case>):Void
    {
        for (condition in conditions)
        {
            var caseData = switch (condition)
            {
                case LislaToEntityCaseCondition.Arr(guard):
                    createTupleCase(guard, caseExpr);
                    
                case LislaToEntityCaseCondition.Str:
                    {
                        values: [macro lisla.core.Lisla.Str(_)],
                        expr: caseExpr,
                    }
                    
                case LislaToEntityCaseCondition.Const(label):
                    var stringExpr:Expr = ExprBuilder.getStringConstExpr(label);
                    {
                        values: [macro lisla.core.Lisla.Str(string)],
                        guard: (macro string.data == $stringExpr),
                        expr: caseExpr,
                    }
            }
            
            outputCases.push(caseData);
        }
    }
}
