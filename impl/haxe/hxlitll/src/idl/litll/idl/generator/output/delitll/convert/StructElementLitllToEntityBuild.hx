package litll.idl.generator.output.delitll.convert;
import haxe.ds.Option;
import haxe.macro.Expr;
import hxext.ds.Result;
import litll.core.Litll;
import litll.idl.exception.IdlException;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.litll2entity.LitllToEntityContext;
import litll.idl.litll2entity.error.LitllToEntityError;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructField;
import litll.idl.std.data.idl.StructFieldKind;

class StructElementLitllToEntityBuild
{
    private var element:StructElement;
    private var id:String;
    private var parent:StructLitllToEntityBuild;
    
    public inline function new(parent:StructLitllToEntityBuild, element:StructElement, id:String) 
    {
        this.parent = parent;
        this.element = element;
        this.id = id;
    }
    
    private inline function addOptionDeclaration(instantationExpr:Expr, name:String):Expr
    {
        parent.declarations.push(macro var $id = haxe.ds.Option.None);
        var nameExpr = ExprBuilder.getStringConstExpr(name);
        
        return macro switch ($i{id})
        {
            case haxe.ds.Option.Some(_):
                return hxext.ds.Result.Err(
                    litll.idl.litll2entity.error.LitllToEntityError.ofLitll(
                        litllData,
                        litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementDuplicated($nameExpr)
                    )
                );
                
            case haxe.ds.Option.None:
                $i{id} = haxe.ds.Option.Some($instantationExpr);
        }
    }
    
    private inline function addArrayDeclaration(instantationExpr:Expr):Expr
    {
        parent.declarations.push(macro var $id = []);
        return macro $i{id}.push($instantationExpr);
    }
    private inline function fieldInstantiation(field:StructField):Expr
    {
        var callExpr = parent.builder.createProcessCallExpr(
            (macro context), 
            parent.parameters, 
            field.type.generalize()
        );
        return macro {
            var context = new litll.idl.litll2entity.LitllToEntityContext(array.data[1], context.config);
            ${ExprBuilder.createGetOrReturnExpr(callExpr)}
        }
    }
    private inline function unfoldInstantiation(field:StructField):Expr
    {
        var callExpr = parent.builder.createProcessCallExpr(
            (macro context), 
            parent.parameters, 
            field.type.generalize()
        );
        return ExprBuilder.createGetOrReturnExpr(callExpr);
    }
    private inline function addFieldCase(field:StructField, caseExpr:Expr):Void
    {
        parent.cases.push(
            parent.builder.createFieldCase(field.name, field.type, parent.parameters.parameters, caseExpr)
        );
    }
    private inline function addUnfoldCase(field:StructField, caseExpr:Expr):Void
    {
        parent.builder.createTypeCase(field.type, parent.parameters.parameters, caseExpr, parent.cases);
    }
    private inline function addNormalReference(field:StructField):Void
    {
        var nameExpr = ExprBuilder.getStringConstExpr(field.name.name);
        parent.references.push(
            macro switch ($i{id})
            {
                case haxe.ds.Option.Some(data):
                    data;
                    
                case haxe.ds.Option.None:
                    return hxext.ds.Result.Err(
                        litll.idl.litll2entity.error.LitllToEntityError.ofLitll(
                            context.litll,
                            litll.idl.litll2entity.error.LitllToEntityErrorKind.StructElementNotFound($nameExpr)
                        )
                    );
            }
        );
    }
    private inline function addDefaultReference(field:StructField, defaultValue:litll.core.Litll):Void
    {
        var nameExpr = ExprBuilder.getStringConstExpr(field.name.name);
        parent.references.push(
            macro switch ($i{id})
            {
                case haxe.ds.Option.Some(data):
                    data;
                    
                case haxe.ds.Option.None:
                    // TODO:
                    null;
            }
        );
    }
    private inline function addDirectReference(field:StructField):Void
    {
        var nameExpr = ExprBuilder.getStringConstExpr(field.name.name);
        parent.references.push(macro $i{id});
    }
    
    public function run():Void
    {
        switch (element)
        {
            case StructElement.Field(field):
                
                switch [field.name.kind, field.defaultValue]
                {
                    case [StructFieldKind.Normal, Option.None]:
                        var instantationExpr = fieldInstantiation(field);
                        var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                        addFieldCase(field, caseExpr);
                        addNormalReference(field);
                        
                    case [StructFieldKind.Normal, Option.Some(defaultValue)]:
                        var instantationExpr = fieldInstantiation(field);
                        var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                        addFieldCase(field, caseExpr);
                        addDefaultReference(field, defaultValue);
                        
                    case [StructFieldKind.Optional, Option.None]:
                        var instantationExpr = fieldInstantiation(field);
                        var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                        addFieldCase(field, caseExpr);
                        addDirectReference(field);
                        
                    case [StructFieldKind.Array, Option.None]:
                        var instantationExpr = fieldInstantiation(field);
                        var caseExpr = addArrayDeclaration(instantationExpr);
                        addFieldCase(field, caseExpr);
                        addDirectReference(field);
                        
                    case [StructFieldKind.Inline, Option.None]:
                        var instantationExpr = unfoldInstantiation(field);
                        var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                        addUnfoldCase(field, caseExpr);
                        addNormalReference(field);
                        
                    case [StructFieldKind.Inline, Option.Some(defaultValue)]:
                        var instantationExpr = unfoldInstantiation(field);
                        var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                        addUnfoldCase(field, caseExpr);
                        addDefaultReference(field, defaultValue);
                        
                    case [StructFieldKind.OptionalInline, Option.None]:
                        var instantationExpr = unfoldInstantiation(field);
                        var caseExpr = addOptionDeclaration(instantationExpr, field.name.name);
                        addUnfoldCase(field, caseExpr);
                        addDirectReference(field);
                        
                    case [StructFieldKind.ArrayInline, Option.None]:
                        var instantationExpr = unfoldInstantiation(field);
                        var caseExpr = addArrayDeclaration(instantationExpr);
                        addUnfoldCase(field, caseExpr);
                        addDirectReference(field);
                        
                    case [StructFieldKind.Merge, Option.None]:
                        // TODO
                        
                    case [StructFieldKind.ArrayInline, Option.Some(_)]
                        | [StructFieldKind.OptionalInline, Option.Some(_)]
                        | [StructFieldKind.Array, Option.Some(_)]
                        | [StructFieldKind.Optional, Option.Some(_)]
                        | [StructFieldKind.Merge, Option.Some(_)]:
                        
                        throw new IdlException("unsupported default value kind: " + field.name.kind);
                }
                
            case StructElement.Label(name) | StructElement.NestedLabel(name):
                switch (name.kind)
                {
                    case StructFieldKind.Normal:
                        parent.declarations.push(macro var $id = haxe.ds.Option.None);
                        
                    case StructFieldKind.Array:
                        parent.declarations.push(macro var $id = []);
                        parent.references.push(macro $i{id});
                        
                    case StructFieldKind.Optional:
                        parent.declarations.push(macro var $id = haxe.ds.Option.None);
                        parent.references.push(macro $i{id});
                        
                    case StructFieldKind.Inline:
                        throw new IdlException("inline suffix(<) for label is not supported");
                        
                    case StructFieldKind.ArrayInline:
                        throw new IdlException("array inline suffix(<..) for label is not supported");
                        
                    case StructFieldKind.OptionalInline:
                        throw new IdlException("optional inline suffix(<?) for label is not supported");
                        
                    case StructFieldKind.Merge:
                        throw new IdlException("merge suffix(<<) for label is not supported");
                }
        }
    }
}