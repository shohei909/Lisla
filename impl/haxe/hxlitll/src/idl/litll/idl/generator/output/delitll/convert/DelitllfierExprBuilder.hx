package litll.idl.generator.output.delitll.convert;
import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Case;
import litll.core.LitllString;
import litll.idl.exception.IdlException;
import litll.idl.generator.data.DelitllfierOutputConfig;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.data.store.HaxeDataConstructorKind;
import litll.idl.generator.output.data.store.HaxeDataConstructorReturnKind;
import litll.idl.generator.output.data.store.HaxeDataInterface;
import litll.idl.generator.output.data.store.HaxeDataInterfaceKind;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyCaseConditionTools;
import litll.idl.generator.output.delitll.match.DelitllfyGuardCondition;
import litll.idl.generator.output.delitll.path.HaxeDelitllfierTypePathPair;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.StructFieldName;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;


class DelitllfierExprBuilder 
{
	public var context(default, null):IdlToHaxeConvertContext;
    private var config:DelitllfierOutputConfig;
    
	public function new (context:IdlToHaxeConvertContext, config:DelitllfierOutputConfig)
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
                            case litll.core.ds.Result.Ok(data):
                                litll.core.ds.Result.Ok(data);
                                
                            case litll.core.ds.Result.Err(data):
                                litll.core.ds.Result.Err(
                                    litll.idl.delitllfy.DelitllfyError.ofLitll(
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
        var funcName = createProcessFuncNameExpr(parameters, destType);
        var processElements = [contextExpr].concat(createParmetersExpr(destType.parameters));
        return macro $funcName($a{processElements});
    }
	public function createProcessFuncExpr(parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr
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
    public function createTupleGuardConditions(elements:Array<TupleElement>, definitionParameters:Array<TypeName>):DelitllfyGuardCondition
    {
        return DelitllfyGuardCondition.createForTuple(elements, context.source, definitionParameters);
    }
    public function createFieldGuardConditions(name:StructFieldName, type:TypeReference, definitionParameters:Array<TypeName>):DelitllfyGuardCondition
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
    public function createFieldCase(name:StructFieldName, type:TypeReference, definitionParameters:Array<TypeName>, caseExpr:Expr):Case
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
        for (caseKind in DelitllfyCaseConditionTools.createForFollowedType(followedType, context.source, definitionParameters))
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
    public static function createTupleCase(guard:DelitllfyGuardCondition, caseExpr:Expr):Case
    {
        var guardConditions = guard.getConditionExprs(macro array);
        return {
            values: [macro litll.core.Litll.Arr(array)],
            guard: if (guardConditions.length == 0) null else ExprBuilder.createAndExpr(guardConditions),
            expr: caseExpr,
        }
    }
}