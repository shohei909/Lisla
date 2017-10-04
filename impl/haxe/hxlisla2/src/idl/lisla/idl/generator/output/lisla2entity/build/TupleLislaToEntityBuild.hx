package arraytree.idl.generator.output.arraytree2entity.build;
import haxe.ds.Option;
import haxe.macro.Expr;
import hxext.ds.Result;
import arraytree.idl.exception.IdlException;
import arraytree.idl.generator.output.entity.EntityHaxeTypePath;
import arraytree.idl.generator.tools.ExprBuilder;
import arraytree.idl.std.entity.idl.Argument;
import arraytree.idl.std.entity.idl.ArgumentKind;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeReference;
import arraytree.idl.std.error.GetConditionError;
import arraytree.idl.std.tools.idl.TupleTools;
import arraytree.idl.std.tools.idl.TypeParameterDeclarationCollection;

class TupleArrayTreeToEntityBuild 
{
    private var elements:Array<TupleElement>;
    public var parameters(default, null):TypeParameterDeclarationCollection;
    public var declarations(default, null):Array<Expr>;
    public var references(default, null):Array<Expr>;
    public var builder(default, null):ArrayTreeToEntityExprBuilder;
    
    public function new(
        builder:ArrayTreeToEntityExprBuilder, 
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
                            var arraytree = ExprBuilder.arraytreeExpr(value);
                            
                            ExprBuilder.createGetOrReturnExpr(
                                macro arrayContext.readWithDefault(
                                    $processFunc,
                                    $guardFunction, 
                                    $arraytree
                                )
                            );
                            
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
                                    var processFunc = builder.createProcessFuncExpr(parameters, destType);
                                    var lengthExpr = ExprBuilder.getIntConstExpr(length);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readFixedInline($processFunc, arrayContext.index + $lengthExpr)); 
                                    
                                case Option.None:
                                    switch (builder.getFixedLength(elements.slice(i + 1), parameters.parameters))
                                    {
                                        case Option.Some(length):
                                            var processFunc = builder.createProcessFuncExpr(parameters, destType);
                                            var lengthExpr = ExprBuilder.getIntConstExpr(length);
                                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readFixedInline($processFunc, arrayContext.length - $lengthExpr)); 
                                            
                                        case Option.None:
                                            var processFunc = builder.createVariableInlineProcessFuncExpr(parameters, destType);
                                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readVariableInline($processFunc)); 
                                    }
                            }
                            
                        case [ArgumentKind.RestInline, Option.None]:
                            var guardFunction = getFirstGuardFuncExpr(data);
                            switch (builder.getInlineFixedLength(data, parameters.parameters))
                            {
                                case Option.Some(length):
                                    var processFunc = builder.createProcessFuncExpr(parameters, destType);
                                    var lengthExpr = ExprBuilder.getIntConstExpr(length);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readFixedRestInline($processFunc, arrayContext.index + $lengthExpr, $guardFunction)); 
                                    
                                case Option.None:
                                    var processFunc = builder.createVariableInlineProcessFuncExpr(parameters, destType);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readVariableRestInline($processFunc, $guardFunction)); 
                            }
                            
                        case [ArgumentKind.OptionalInline, Option.None]:
                            var guardFunction = getFirstGuardFuncExpr(data);
                            switch (builder.getInlineFixedLength(data, parameters.parameters))
                            {
                                case Option.Some(length):
                                    var processFunc = builder.createProcessFuncExpr(parameters, destType);
                                    var lengthExpr = ExprBuilder.getIntConstExpr(length);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readFixedOptionalInline($processFunc, arrayContext.index + $lengthExpr, $guardFunction)); 
                                    
                                case Option.None:
                                    var processFunc = builder.createVariableInlineProcessFuncExpr(parameters, destType);
                                    ExprBuilder.createGetOrReturnExpr(macro arrayContext.readVariableOptionalInline($processFunc, $guardFunction)); 
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
