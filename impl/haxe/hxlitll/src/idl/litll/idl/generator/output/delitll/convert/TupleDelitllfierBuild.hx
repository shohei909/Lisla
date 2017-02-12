package litll.idl.generator.output.delitll.convert;
import haxe.ds.Option;
import haxe.macro.Expr;
import litll.core.ds.Result;
import litll.idl.exception.IdlException;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentKind;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.error.GetConditionErrorKindTools;
import litll.idl.std.tools.idl.TupleTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

class TupleDelitllfierBuild 
{
    private var elements:Array<TupleElement>;
    public var parameters(default, null):TypeParameterDeclarationCollection;
    public var declarations(default, null):Array<Expr>;
    public var references(default, null):Array<Expr>;
    public var builder(default, null):DelitllfierExprBuilder;
    
    public function new(
        builder:DelitllfierExprBuilder, 
        parameters:TypeParameterDeclarationCollection,
        elements:Array<TupleElement>
    ) 
    {
        this.elements = elements;
        this.parameters = parameters;
        this.builder = builder;
        
        this.references = [];
        this.declarations = [];
        
        run();
    }
    
    private function run():Void
    {
        for (i in 0...elements.length)
        {
            var element = elements[i];
            switch (element)
            {
                case TupleElement.Argument(data):
                    var destType = data.type.generalize();
                    var expr = switch [data.name.kind, data.defaultValue]
                    {
                        case [ArgumentKind.Normal, Option.Some(value)]:
                            var processFunc = builder.createProcessFuncExpr(parameters, destType);
                            var guardFunction = getGuardFuncExpr(data.type);
                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readWithDefault($processFunc, $guardFunction, null));
                            
                        case [ArgumentKind.Normal, Option.None]:
                            var processFunc = builder.createProcessFuncExpr(parameters, destType);
                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.read($processFunc));
                            
                        case [ArgumentKind.Rest, Option.None]:
                            var processFunc = builder.createProcessFuncExpr(parameters, destType);
                            var guardFunction = getGuardFuncExpr(data.type);
                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readRest($processFunc, $guardFunction)); 
                            
                        case [ArgumentKind.Optional, Option.None]:
                            var processFunc = builder.createProcessFuncExpr(parameters, destType);
                            var guardFunction = getGuardFuncExpr(data.type);
                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readOptional($processFunc, $guardFunction)); 
                            
                        case [ArgumentKind.Inline, Option.None]:
                            switch (builder.getInlineFixedLength(data, parameters.parameters))
                            {
                                case Option.Some(length):
                                    var processFunc = builder.createFixedInlineProcessFuncExpr(parameters, destType);
                                    var lengthExpr = ExprBuilder.getIntConstExpr(length);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readFixedInline($processFunc, $lengthExpr)); 
                                    
                                case Option.None:
                                    switch (builder.getFixedLength(elements.slice(i + 1), parameters.parameters))
                                    {
                                        case Option.Some(length):
                                            var processFunc = builder.createFixedInlineProcessFuncExpr(parameters, destType);
                                            var lengthExpr = ExprBuilder.getIntConstExpr(length);
                                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readFixedInline($processFunc, arrayContext.length - $lengthExpr)); 
                                            
                                        case Option.None:
                                            var processFunc = builder.createVariableInlineProcessFuncExpr(parameters, destType);
                                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readValiableInline($processFunc)); 
                                    }
                            }
                            
                        case [ArgumentKind.RestInline, Option.None]:
                            var guardFunction = getFirstGuardFuncExpr(data);
                            switch (builder.getInlineFixedLength(data, parameters.parameters))
                            {
                                case Option.Some(length):
                                    var processFunc = builder.createFixedInlineProcessFuncExpr(parameters, destType);
                                    var lengthExpr = ExprBuilder.getIntConstExpr(length);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readFixedRestInline($processFunc, $lengthExpr, $guardFunction)); 
                                    
                                case Option.None:
                                    var processFunc = builder.createVariableInlineProcessFuncExpr(parameters, destType);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readValiableRestInline($processFunc, $guardFunction)); 
                            }
                            
                        case [ArgumentKind.OptionalInline, Option.None]:
                            var guardFunction = getFirstGuardFuncExpr(data);
                            switch (builder.getInlineFixedLength(data, parameters.parameters))
                            {
                                case Option.Some(length):
                                    var processFunc = builder.createFixedInlineProcessFuncExpr(parameters, destType);
                                    var lengthExpr = ExprBuilder.getIntConstExpr(length);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readFixedOptionalInline($processFunc, $lengthExpr, $guardFunction)); 
                                    
                                case Option.None:
                                    var processFunc = builder.createVariableInlineProcessFuncExpr(parameters, destType);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readValiableOptionalInline($processFunc, $guardFunction)); 
                            }
                            
                        case [ArgumentKind.Rest, Option.Some(_)] 
                            | [ArgumentKind.Inline, Option.Some(_)]
                            | [ArgumentKind.Optional, Option.Some(_)]
                            | [ArgumentKind.OptionalInline, Option.Some(_)]
                            | [ArgumentKind.RestInline, Option.Some(_)]:
                            throw new IdlException("unsupported default value kind: " + data.name.kind);
                    }
                    
                    var name = "arg" + references.length;
                    declarations.push(macro var $name = $expr);
                    references.push(macro $i{name});
                    
                case TupleElement.Label(data):
                    var value = ExprBuilder.getStringConstExpr(data.data);
                    declarations.push(macro arrayContext.readLabel($value));
            }
        }
    }
    
    private function getGuardFuncExpr(type:TypeReference):Expr
    {
        var cases = [];
        builder.createTypeCase(type, parameters.parameters, macro true, cases);
        return _getGuardFuncExpr(cases);
    }
    
    private function getFirstGuardFuncExpr(argument:Argument):Expr
    {
        var cases = [];
        builder.createFirstTypeCase(argument, parameters.parameters, macro true, cases);
        return _getGuardFuncExpr(cases);
    }
    
    private function _getGuardFuncExpr(cases:Array<Case>):Expr
    {
        cases.push(
            {
                values: [macro _],
                expr: macro false,
            }
        );
        var switchExpr = ExprBuilder.createSwitchExpr(macro data, cases);
        return macro function (data)
        {
            return $switchExpr;
        }
    }
}
