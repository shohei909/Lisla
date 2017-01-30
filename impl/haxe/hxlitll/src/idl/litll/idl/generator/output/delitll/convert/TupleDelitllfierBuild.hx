package litll.idl.generator.output.delitll.convert;
import haxe.ds.Option;
import haxe.macro.Expr;
import litll.idl.exception.IdlException;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.std.data.idl.ArgumentKind;
import litll.idl.std.data.idl.TupleElement;
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
        for (argument in elements)
        {
            switch (argument)
            {
                case TupleElement.Argument(data):
                    var processFunc = builder.createProcessFuncExpr(parameters, data.type.generalize());
                    
                    var expr = switch [data.name.kind, data.defaultValue]
                    {
                        case [ArgumentKind.Normal, Option.Some(value)]:
                            // TODO: default value
                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readWithDefault($processFunc, null));
                            
                        case [ArgumentKind.Normal, Option.None]:
                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.read($processFunc));
                            
                        case [ArgumentKind.Rest, Option.None]:
                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readRest($processFunc)); 
                            
                        case [ArgumentKind.Optional, Option.None]:
                            ExprBuilder.createGetOrReturnExpr(macro arrayContext.readOptional($processFunc)); 
                            
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
                    var value = ExprBuilder.getStringConstExpr(data.data);
                    declarations.push(macro arrayContext.readLabel($value));
            }
        }
    }
}