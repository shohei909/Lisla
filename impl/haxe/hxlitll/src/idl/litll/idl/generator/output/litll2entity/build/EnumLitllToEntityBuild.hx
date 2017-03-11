package lisla.idl.generator.output.lisla2entity.build;
import haxe.macro.Expr;
import hxext.ds.Result;
import lisla.core.LislaString;
import lisla.idl.exception.IdlException;
import lisla.idl.generator.output.entity.EntityHaxeTypePath;
import lisla.idl.generator.output.entity.store.HaxeEntityInterface;
import lisla.idl.generator.tools.ExprBuilder;
import lisla.idl.lisla2entity.LislaToEntityArrayContext;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
import lisla.idl.std.entity.idl.EnumConstructor;
import lisla.idl.std.entity.idl.EnumConstructorKind;
import lisla.idl.std.entity.idl.EnumConstructorName;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.entity.idl.TypeReference;
import lisla.idl.std.tools.idl.TypeParameterDeclarationCollection;

class EnumLislaToEntityBuild 
{
    private var targetList:Array<Expr> = [];
    public var cases(default, null):Array<Case> = [];
    
    private var constructors:Array<EnumConstructor>;
    private var parameters:TypeParameterDeclarationCollection;
    private var builder:LislaToEntityExprBuilder;
    private var dataInterface:HaxeEntityInterface;
        
    public function new(builder:LislaToEntityExprBuilder, dataInterface:HaxeEntityInterface, parameters:TypeParameterDeclarationCollection, constructors:Array<EnumConstructor>) 
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
                            var label = TupleElement.Label(new LislaString(name.name, name.tag));
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
                                    
                                case TupleElement.Label(lislaString):
                                    addPrimitiveCase(name, lislaString.data);
                            }
                    }
            }
        }
        
        cases.push(
            {
                // case data:
                values : [macro data],
                expr: macro hxext.ds.Result.Err(
                    lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(
                        context.lisla, 
                        lisla.idl.lisla2entity.error.LislaToEntityErrorKind.UnmatchedEnumConstructor([$a{targetList}])
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
            var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
            var data = $instantiationExpr;
            switch (arrayContext.closeOrError())
            {
                case haxe.ds.Option.None:
                    data;
                    
                case haxe.ds.Option.Some(error):
                    hxext.ds.Result.Err(error);
            }
        }
        
        cases.push(LislaToEntityExprBuilder.createTupleCase(guard, caseExpr));
    }
    inline function addTupleCase(name:EnumConstructorName, elements:Array<TupleElement>):Void
    {
        var string = name.name;
        addTarget(string);
        
        var build = new TupleLislaToEntityBuild(builder, parameters, elements);
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
                values: [macro lisla.core.Lisla.Str(data)],
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