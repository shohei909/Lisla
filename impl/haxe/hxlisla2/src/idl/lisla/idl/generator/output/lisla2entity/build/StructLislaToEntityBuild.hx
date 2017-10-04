package arraytree.idl.generator.output.arraytree2entity.build;
import haxe.macro.Expr;
import hxext.ds.Result;
import arraytree.idl.generator.output.entity.EntityHaxeTypePath;
import arraytree.idl.generator.tools.ExprBuilder;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityContext;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
import arraytree.idl.std.entity.idl.StructElement;
import arraytree.idl.std.tools.idl.TypeParameterDeclarationCollection;

class StructArrayTreeToEntityBuild 
{
    private var elements:Array<StructElement>;
    private var sourcePath:EntityHaxeTypePath;
    public var parameters(default, null):TypeParameterDeclarationCollection;
    public var declarations(default, null):Array<Expr>;
    public var references(default, null):Array<Expr>;
    public var cases(default, null):Array<Case>;
    public var builder(default, null):ArrayTreeToEntityExprBuilder;
    
    public function new(
        builder:ArrayTreeToEntityExprBuilder, 
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
            new StructElementArrayTreeToEntityBuild(this, element, id).run();
        }
        var targetsExpr = ExprBuilder.getStringArrayExpr(targets);
        
        cases.push(
            {
                // case data:
                values : [macro arraytreeData],
                expr: macro return hxext.ds.Result.Error(
                    arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError.ofArrayTree(
                        arraytreeData, 
                        arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind.UnmatchedStructElement(${targetsExpr})
                    )
                )
            }
        );
        var switchExpr = ExprBuilder.createSwitchExpr(macro arraytreeData, cases);
        declarations.push(
            macro for (arraytreeData in array)
            {
                var context = new arraytree.idl.arraytree2entity.ArrayTreeToEntityContext(arraytreeData, context.config);
                $switchExpr;
            }
        );
    }
}
