package litll.idl.generator.output.delitll.convert;
import haxe.macro.Expr;
import litll.core.LitllString;
import litll.idl.exception.IdlException;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorKind;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

class EnumDelitllfierBuild 
{
    private var targetList:Array<Expr> = [];
    public var cases(default, null):Array<Case> = [];
    
    private var constructors:Array<EnumConstructor>;
    private var parameters:TypeParameterDeclarationCollection;
    private var sourcePath:HaxeDataTypePath;
    private var builder:DelitllfierExprBuilder;
        
    public function new(builder:DelitllfierExprBuilder, sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, constructors:Array<EnumConstructor>) 
    {
        this.builder = builder;
        this.sourcePath = sourcePath;
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
                            
                        case EnumConstructorKind.Unfold:
                            throw new IdlException("unfold is not allowed for primitive enum constructor");
                    }
                    
                case EnumConstructor.Parameterized(parameterized):
                    var elements = parameterized.elements;
                    var name = parameterized.name;
                    switch (parameterized.name.kind)
                    {
                        case EnumConstructorKind.Normal:
                            var label = TupleElement.Label(new LitllString(name.name, name.tag));
                            addTupleCase(name, [label].concat(elements));
                    
                        case EnumConstructorKind.Tuple:
                            addTupleCase(name, elements);
                            
                        case EnumConstructorKind.Unfold:
                            if (elements.length != 1)
                            {
                                throw new IdlException("unfold target type number must be one. but actual " + elements.length);
                            }
                            
                            switch (elements[0])
                            {
                                case TupleElement.Argument(argument):
                                    addUnfoldCase(name, argument.type);
                                    
                                case TupleElement.Label(litllString):
                                    addPrimitiveCase(name, litllString.data);
                            }
                    }
            }
        }
        
        cases.push(
            {
                // case data:
                values : [macro data],
                expr: macro litll.core.ds.Result.Err(
                    litll.idl.delitllfy.DelitllfyError.ofLitll(
                        context.litll, 
                        litll.idl.delitllfy.DelitllfyErrorKind.UnmatchedEnumConstructor([$a{targetList}])
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
            var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(array, 0, context.config);
            var data = $instantiationExpr;
            switch (arrayContext.closeOrError())
            {
                case haxe.ds.Option.None:
                    data;
                    
                case haxe.ds.Option.Some(error):
                    litll.core.ds.Result.Err(error);
            }
        }
        
        cases.push(DelitllfierExprBuilder.createTupleCase(guard, caseExpr));
    }
    inline function addTupleCase(name:EnumConstructorName, elements:Array<TupleElement>):Void
    {
        var string = name.name;
        addTarget(string);
        
        var build = new TupleDelitllfierBuild(builder, parameters, elements);
        var instantiationExpr = builder.createEnumInstantiationExpr(build.declarations, build.references, sourcePath, name, parameters);
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
                values: [macro litll.core.Litll.Str(data)],
                guard: (macro data.data == $stringExpr),
                expr: instantiationExpr,
            }
        );
    }
    inline function addPrimitiveCase(name:EnumConstructorName, label:String):Void
    {
        var string = name.name;
        addTarget(string);
        
        var instantiationExpr = builder.createEnumInstantiationExpr([], [], sourcePath, name, parameters);
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
            sourcePath, name, parameters
        );
        _addUnfoldCase(instantiationExpr, type);
    }

}