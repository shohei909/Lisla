package litll.idl.generator.output.delitll.convert;
import haxe.macro.Expr;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.litll2backend.LitllToEntityContext;
import litll.idl.litll2backend.LitllToEntityError;
import litll.idl.litll2backend.LitllToEntityErrorKind;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

class StructLitllToEntityBuild 
{
    private var elements:Array<StructElement>;
    private var sourcePath:HaxeDataTypePath;
    public var parameters(default, null):TypeParameterDeclarationCollection;
    public var declarations(default, null):Array<Expr>;
    public var references(default, null):Array<Expr>;
    public var cases(default, null):Array<Case>;
    public var builder(default, null):LitllToEntityExprBuilder;
    
    public function new(
        builder:LitllToEntityExprBuilder, 
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
            new StructElementLitllToEntityBuild(this, element, id).run();
        }
        
        cases.push(
            {
                // case data:
                values : [macro litllData],
                expr: macro return litll.core.ds.Result.Err(
                    litll.idl.litll2backend.LitllToEntityError.ofLitll(
                        litllData, 
                        // TODO: target list
                        litll.idl.litll2backend.LitllToEntityErrorKind.UnmatchedStructElement([])
                    )
                )
            }
        );
        var switchExpr = ExprBuilder.createSwitchExpr(macro litllData, cases);
        declarations.push(
            macro for (litllData in array.data)
            {
                var context = new litll.idl.litll2backend.LitllToEntityContext(litllData, context.config);
                $switchExpr;
            }
        );
    }
}
