package litll.idl.generator.output.delitll.convert;
import haxe.macro.Expr;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

class StructDelitllfierBuild 
{
    private var elements:Array<StructElement>;
    private var sourcePath:HaxeDataTypePath;
    public var parameters(default, null):TypeParameterDeclarationCollection;
    public var declarations(default, null):Array<Expr>;
    public var references(default, null):Array<Expr>;
    public var cases(default, null):Array<Case>;
    public var builder(default, null):DelitllfierExprBuilder;
    
    public function new(
        builder:DelitllfierExprBuilder, 
        sourcePath:HaxeDataTypePath, 
        parameters:TypeParameterDeclarationCollection, 
        elements:Array<StructElement>) 
    {
        this.sourcePath = sourcePath;
        this.parameters = parameters;
        this.builder = builder;
        this.elements = elements;
        
        this.cases = [];
        this.references = [];
        this.declarations = [];
        
        run();
    }
    
    private function run():Void
    {
        for (element in elements)
        {
            var id = "arg" + references.length;
            new StructElementDelitllfierBuild(this, element, id).run();
        }
        
        cases.push(
            {
                // case data:
                values : [macro litllData],
                expr: macro return litll.core.ds.Result.Err(
                    litll.idl.delitllfy.DelitllfyError.ofLitll(
                        litllData, 
                        // TODO: target list
                        litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedStructElement([])
                    )
                )
            }
        );
        var switchExpr = ExprBuilder.createSwitchExpr(macro litllData, cases);
        declarations.push(
            macro for (litllData in array.data)
            {
                var context = new litll.idl.delitllfy.DelitllfyContext(litllData, context.config);
                $switchExpr;
            }
        );
    }
}