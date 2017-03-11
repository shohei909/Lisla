package litll.idl.generator.output.litll2entity.build;
import haxe.macro.Expr;
import hxext.ds.Result;
import litll.idl.generator.output.entity.EntityHaxeTypePath;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.litll2entity.LitllToEntityContext;
import litll.idl.litll2entity.error.LitllToEntityError;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

class StructLitllToEntityBuild 
{
    private var elements:Array<StructElement>;
    private var sourcePath:EntityHaxeTypePath;
    public var parameters(default, null):TypeParameterDeclarationCollection;
    public var declarations(default, null):Array<Expr>;
    public var references(default, null):Array<Expr>;
    public var cases(default, null):Array<Case>;
    public var builder(default, null):LitllToEntityExprBuilder;
    
    public function new(
        builder:LitllToEntityExprBuilder, 
        sourcePath:EntityHaxeTypePath, 
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
        var targets = [];
        for (element in elements)
        {
            targets.push(element.getElementName().name);
            var id = "arg" + references.length;
            new StructElementLitllToEntityBuild(this, element, id).run();
        }
        var targetsExpr = ExprBuilder.getStringArrayExpr(targets);
        
        cases.push(
            {
                // case data:
                values : [macro litllData],
                expr: macro return hxext.ds.Result.Err(
                    litll.idl.litll2entity.error.LitllToEntityError.ofLitll(
                        litllData, 
                        litll.idl.litll2entity.error.LitllToEntityErrorKind.UnmatchedStructElement(${targetsExpr})
                    )
                )
            }
        );
        var switchExpr = ExprBuilder.createSwitchExpr(macro litllData, cases);
        declarations.push(
            macro for (litllData in array.data)
            {
                var context = new litll.idl.litll2entity.LitllToEntityContext(litllData, context.config);
                $switchExpr;
            }
        );
    }
}
