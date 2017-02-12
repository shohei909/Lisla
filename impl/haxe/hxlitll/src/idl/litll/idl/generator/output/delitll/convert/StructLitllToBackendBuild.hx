package litll.idl.generator.output.delitll.convert;
import haxe.macro.Expr;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.litll2backend.LitllToBackendContext;
import litll.idl.litll2backend.LitllToBackendError;
import litll.idl.litll2backend.LitllToBackendErrorKind;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

class StructLitllToBackendBuild 
{
    private var elements:Array<StructElement>;
    private var sourcePath:HaxeDataTypePath;
    public var parameters(default, null):TypeParameterDeclarationCollection;
    public var declarations(default, null):Array<Expr>;
    public var references(default, null):Array<Expr>;
    public var cases(default, null):Array<Case>;
    public var builder(default, null):LitllToBackendExprBuilder;
    
    public function new(
        builder:LitllToBackendExprBuilder, 
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
            new StructElementLitllToBackendBuild(this, element, id).run();
        }
        
        cases.push(
            {
                // case data:
                values : [macro litllData],
                expr: macro return litll.core.ds.Result.Err(
                    litll.idl.litll2backend.LitllToBackendError.ofLitll(
                        litllData, 
                        // TODO: target list
                        litll.idl.litll2backend.LitllToBackendErrorKind.UnmatchedStructElement([])
                    )
                )
            }
        );
        var switchExpr = ExprBuilder.createSwitchExpr(macro litllData, cases);
        declarations.push(
            macro for (litllData in array.data)
            {
                var context = new litll.idl.litll2backend.LitllToBackendContext(litllData, context.config);
                $switchExpr;
            }
        );
    }
}
