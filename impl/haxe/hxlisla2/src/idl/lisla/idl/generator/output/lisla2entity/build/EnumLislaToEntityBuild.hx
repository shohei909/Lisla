package arraytree.idl.generator.output.arraytree2entity.build;
import haxe.macro.Expr;
import hxext.ds.Result;
import arraytree.data.meta.core.StringWithMetadata;
import arraytree.idl.exception.IdlException;
import arraytree.idl.generator.output.entity.EntityHaxeTypePath;
import arraytree.idl.generator.output.entity.store.HaxeEntityInterface;
import arraytree.idl.generator.tools.ExprBuilder;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityArrayContext;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
import arraytree.idl.std.entity.idl.EnumConstructor;
import arraytree.idl.std.entity.idl.EnumConstructorKind;
import arraytree.idl.std.entity.idl.EnumConstructorName;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeReference;
import arraytree.idl.std.tools.idl.TypeParameterDeclarationCollection;

class EnumArrayTreeToEntityBuild 
{
    private var targetList:Array<Expr> = [];
    public var cases(default, null):Array<Case> = [];
    
    private var constructors:Array<EnumConstructor>;
    private var parameters:TypeParameterDeclarationCollection;
    private var builder:ArrayTreeToEntityExprBuilder;
    private var dataInterface:HaxeEntityInterface;
        
    public function new(builder:ArrayTreeToEntityExprBuilder, dataInterface:HaxeEntityInterface, parameters:TypeParameterDeclarationCollection, constructors:Array<EnumConstructor>) 
    {
        this.builder = builder;
        this.dataInterface = dataInterface;
        this.parameters = parameters;
        this.constructors = constructors;
        
        run();
    }
    
    private function run():Void
    {
        for (constructor in constructors)
        {
            switch (constructor)
            {
                case EnumConstructor.Primitive(name):
                    switch (name.kind)
                    {
                        case EnumConstructorKind.Normal:
                            addPrimitiveCase(name, name.name);
                    
                        case EnumConstructorKind.Tuple:
                            throw new IdlException("tuple is not allowed for primitive enum constructor");
                            
                        case EnumConstructorKind.Inline:
                            throw new IdlException("inline is not allowed for primitive enum constructor");
                    }
                    
                case EnumConstructor.Parameterized(parameterized):
                    var elements = parameterized.elements;
                    var name = parameterized.name;
                    switch (parameterized.name.kind)
                    {
                        case EnumConstructorKind.Normal:
                            var label = TupleElement.Label(new StringWithMetadata(name.name, name.metadata));
                            addTupleCase(name, [label].concat(elements));
                    
                        case EnumConstructorKind.Tuple:
                            addTupleCase(name, elements);
                            
                        case EnumConstructorKind.Inline:
                            if (elements.length != 1)
                            {
                                throw new IdlException("inline target type number must be one. but actual " + elements.length);
                            }
                            
                            switch (elements[0])
                            {
                                case TupleElement.Argument(argument):
                                    addUnfoldCase(name, argument.type);
                                    
                                case TupleElement.Label(arraytreeString):
                                    addPrimitiveCase(name, arraytreeString.data);
                            }
                    }
            }
        }
        
        cases.push(
            {
                // case data:
                values : [macro data],
                expr: macro hxext.ds.Result.Error(
                    arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError.ofArrayTree(
                        context.arraytree, 
                        arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind.UnmatchedEnumConstructor([$a{targetList}])
                    )
                )
            }
        );
    }
    
    inline function addTarget(string:String):Void
    {
        targetList.push(
            {
                expr: ExprDef.EConst(Constant.CString(string)),
                pos: null,
            }
        );
    }
    inline function _addTupleCase(instantiationExpr:Expr, elements:Array<TupleElement>):Void
    {
        var guard = builder.createTupleGuardConditions(elements, parameters.parameters);
        var caseExpr = macro  {
            var arrayContext = new arraytree.idl.arraytree2entity.ArrayTreeToEntityArrayContext(array, 0, context.config);
            var data = $instantiationExpr;
            switch (arrayContext.closeOrError())
            {
                case haxe.ds.Option.None:
                    data;
                    
                case haxe.ds.Option.Some(error):
                    hxext.ds.Result.Error(error);
            }
        }
        
        cases.push(ArrayTreeToEntityExprBuilder.createTupleCase(guard, caseExpr));
    }
    inline function addTupleCase(name:EnumConstructorName, elements:Array<TupleElement>):Void
    {
        var string = name.name;
        addTarget(string);
        
        var build = new TupleArrayTreeToEntityBuild(builder, parameters, elements);
        var instantiationExpr = builder.createEnumInstantiationExpr(build.declarations, build.references, dataInterface.path, name, parameters);
        _addTupleCase(instantiationExpr, elements);
    }
    inline function _addPrimitiveCase(instantiationExpr:Expr, label:String):Void
    {
        var stringExpr:Expr = {
            expr: ExprDef.EConst(Constant.CString(label)),
            pos: null,
        };
        cases.push(
            {
                values: [macro arraytree.data.tree.al.AlTreeKind.Leaf(data)],
                guard: (macro data.data == $stringExpr),
                expr: instantiationExpr,
            }
        );
    }
    inline function addPrimitiveCase(name:EnumConstructorName, label:String):Void
    {
        var string = name.name;
        addTarget(string);
        
        var instantiationExpr = builder.createEnumInstantiationExpr([], [], dataInterface.path, name, parameters);
        _addPrimitiveCase(instantiationExpr, label);
    }
    function _addUnfoldCase(instantiationExpr:Expr, type:TypeReference):Void
    {
        builder.createTypeCase(type, parameters.parameters, instantiationExpr, cases);
    }
    
    inline function addUnfoldCase(name:EnumConstructorName, type:TypeReference):Void
    {
        var callExpr = builder.createProcessCallExpr((macro context), parameters, type.generalize());
        var instantiationExpr = builder.createEnumInstantiationExpr(
            [], 
            [ExprBuilder.createGetOrReturnExpr(callExpr)], 
            dataInterface.path, name, parameters
        );
        _addUnfoldCase(instantiationExpr, type);
    }

}