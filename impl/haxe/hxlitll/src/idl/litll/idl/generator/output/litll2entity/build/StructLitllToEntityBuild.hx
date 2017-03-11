package lisla.idl.generator.output.lisla2entity.build;
import haxe.macro.Expr;
import hxext.ds.Result;
import lisla.idl.generator.output.entity.EntityHaxeTypePath;
import lisla.idl.generator.tools.ExprBuilder;
import lisla.idl.lisla2entity.LislaToEntityContext;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
import lisla.idl.std.entity.idl.StructElement;
import lisla.idl.std.tools.idl.TypeParameterDeclarationCollection;

class StructLislaToEntityBuild 
{
    private var elements:Array<StructElement>;
    private var sourcePath:EntityHaxeTypePath;
    public var parameters(default, null):TypeParameterDeclarationCollection;
    public var declarations(default, null):Array<Expr>;
    public var references(default, null):Array<Expr>;
    public var cases(default, null):Array<Case>;
    public var builder(default, null):LislaToEntityExprBuilder;
    
    public function new(
        builder:LislaToEntityExprBuilder, 
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
            new StructElementLislaToEntityBuild(this, element, id).run();
        }
        var targetsExpr = ExprBuilder.getStringArrayExpr(targets);
        
        cases.push(
            {
                // case data:
                values : [macro lislaData],
                expr: macro return hxext.ds.Result.Err(
                    lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(
                        lislaData, 
                        lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedStructElement(${targetsExpr})
                    )
                )
            }
        );
        var switchExpr = ExprBuilder.createSwitchExpr(macro lislaData, cases);
        declarations.push(
            macro for (lislaData in array.data)
            {
                var context = new lisla.idl.lisla2entity.LislaToEntityContext(lislaData, context.config);
                $switchExpr;
            }
        );
    }
}
