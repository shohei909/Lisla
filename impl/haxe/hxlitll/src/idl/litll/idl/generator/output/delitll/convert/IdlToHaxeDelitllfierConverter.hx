package litll.idl.generator.output.delitll.convert;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import litll.core.Litll;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.generator.data.DelitllfierOutputConfig;
import litll.idl.generator.output.IdlToHaxeConvertContext;
import litll.idl.generator.output.data.store.HaxeDataInterface;
import litll.idl.generator.output.delitll.path.HaxeDelitllfierTypePathPair;
import litll.idl.generator.source.validate.InlinabilityOnTuple;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.tools.idl.TypeNameTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;

class IdlToHaxeDelitllfierConverter
{
    private var builder:DelitllfierExprBuilder;
    
    private var pathPair:HaxeDelitllfierTypePathPair;
    private var addtionalArgs:Array<FunctionArg>;
    private var dataTypePath:ComplexType;
	private var dataInterface:HaxeDataInterface;
    private var parameters:TypeParameterDeclarationCollection;
    private var definition:IdlTypeDefinition;
    
	private function new (context:IdlToHaxeConvertContext, config:DelitllfierOutputConfig)
	{
		this.builder = new DelitllfierExprBuilder(context, config);
	}
	
	public static function convertType(pathPair:HaxeDelitllfierTypePathPair, context:IdlToHaxeConvertContext, config:DelitllfierOutputConfig):HaxeTypeDefinition
	{
		return new IdlToHaxeDelitllfierConverter(context, config).run(pathPair);
	}
	
	private function run(pathPair:HaxeDelitllfierTypePathPair):HaxeTypeDefinition
	{
        this.pathPair = pathPair;
        this.definition = pathPair.typeInfo.definition;
        var typeParameters = pathPair.typeInfo.definition.getTypeParameters();
        this.parameters = typeParameters.collect();
        
        this.addtionalArgs = typeParameters.toHaxeDelitllfierArgs(builder.context.dataOutputConfig);
        this.dataInterface = pathPair.typeInfo.dataInterface;
        
        var dataPath = dataInterface.path;
        
        this.dataTypePath = ComplexType.TPath(
			{
				pack : dataPath.getModuleArray(),
				name : dataPath.typeName.toString(),
                params : TypeNameTools.toHaxeParams(parameters.parameters)
			}
		);
     
        var fields = [
			createProcessFunction()
        ];
        
        switch (pathPair.typeInfo.inlinabilityOnTuple)
        {
            case InlinabilityOnTuple.Never:
                
            case InlinabilityOnTuple.FixedLength:
                createFixedInlineProcessFunction();
                
            case InlinabilityOnTuple.Always:
                createFixedInlineProcessFunction();
                createVariableInlineProcessFunction();
        }
        
		return {
			pack : pathPair.delitllfierPath.getModuleArray(),
			name : pathPair.delitllfierPath.typeName.toString(),
			params: [], 
			pos : null,
			kind : TypeDefKind.TDClass(null, null, false),
			fields : fields,
		}
	}
    
    public function createProcessFunction():Field
    {
        var processExpr = switch (definition)
		{
			case IdlTypeDefinition.Newtype(name, destType):
				createNewtypeExpr(destType.generalize());
				
			case IdlTypeDefinition.Tuple(name, elements):
				createTupleExpr(elements);
                
			case IdlTypeDefinition.Enum(name, constructors):
                createEnumExpr(constructors);
				
			case IdlTypeDefinition.Struct(name, elements):
				createStructExpr(elements);
		}
        
		var args = [
			{
				name: "context",
				type: (macro : litll.idl.delitllfy.DelitllfyContext)
			}
		];
        
		for (arg in addtionalArgs)
		{
			args.push(arg);
		}
        
        return {
            name : "process",
            kind : FieldType.FFun(
                {
                    args: args,
                    ret: macro:litll.core.ds.Result<$dataTypePath, litll.idl.delitllfy.DelitllfyError>,
                    expr: processExpr,
                    params : TypeNameTools.toHaxeParamDecls(parameters.parameters),
                }
            ),
            access: [Access.APublic, Access.AStatic],
            pos: null,
        }
    }

	private function createFixedInlineProcessFunction():Field
    {
        var processExpr = switch (definition)
		{
			case IdlTypeDefinition.Newtype(name, destType):
                macro null;
				
			case IdlTypeDefinition.Tuple(name, elements):
				macro null;
                
			case IdlTypeDefinition.Enum(name, constructors):
		        macro null;
				
			case IdlTypeDefinition.Struct(name, elements):
				macro null;
		}
        
		var args = [
			{
				name: "context",
				type: (macro : litll.idl.delitllfy.DelitllfyArrayContext)
			}
		].concat(addtionalArgs);
        
        return {
            name : "fixedInlineProcess",
            kind : FieldType.FFun(
                {
                    args: args,
                    ret: macro:litll.core.ds.Result<$dataTypePath, litll.idl.delitllfy.DelitllfyError>,
                    expr: processExpr,
                    params : TypeNameTools.toHaxeParamDecls(parameters.parameters),
                }
            ),
            access: [Access.APublic, Access.AStatic],
            pos: null,
        }
    }
    
	private function createVariableInlineProcessFunction():Field
    {
        var processExpr = switch (definition)
		{
			case IdlTypeDefinition.Newtype(name, destType):
                macro null;
				
			case IdlTypeDefinition.Tuple(name, elements):
				macro null;
                
			case IdlTypeDefinition.Enum(name, constructors):
		        macro null;
				
			case IdlTypeDefinition.Struct(name, elements):
				macro null;
		}
        
		var args = [
			{
				name: "context",
				type: (macro : litll.idl.delitllfy.DelitllfyArrayContext)
			}
		].concat(addtionalArgs);
        
		for (arg in addtionalArgs)
		{
			args.push(arg);
		}
        
        return {
            name : "valiableInlineProcess",
            kind : FieldType.FFun(
                {
                    args: args,
                    ret: macro:litll.core.ds.Result<$dataTypePath, litll.idl.delitllfy.DelitllfyError>,
                    expr: processExpr,
                    params : TypeNameTools.toHaxeParamDecls(parameters.parameters),
                }
            ),
            access: [Access.APublic, Access.AStatic],
            pos: null,
        }
    }
    
    // ==============================================================
    // newtype
    // ==============================================================
    private function createNewtypeExpr(destType:GenericTypeReference):Expr 
    {
		var callExpr = builder.createProcessCallExpr((macro context), parameters, destType);
		var instantiationExpr = builder.createClassInstantiationExpr((macro context), [], [(macro data)], dataInterface, parameters);
		
		return macro {
			return switch ($callExpr)
			{
				case litll.core.ds.Result.Ok(data):
					$instantiationExpr;
					
				case litll.core.ds.Result.Err(data):
					litll.core.ds.Result.Err(data);
			}
		}
	}
    
    // ==============================================================
    // tuple
    // ==============================================================
    private function createTupleExpr(elements:Array<TupleElement>):Expr 
	{
        var build = new TupleDelitllfierBuild(builder, parameters, elements);
		var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, dataInterface, parameters);
        
        return macro {
            return switch (context.litll)
            {
                case litll.core.Litll.Str(_):
                    litll.core.ds.Result.Err(
                        litll.idl.delitllfy.DelitllfyError.ofLitll(
                            context.litll,
                            litll.idl.delitllfy.DelitllfyErrorKind.CantBeString
                        )
                    );
                    
                case litll.core.Litll.Arr(data):
                    var arrayContext = new litll.idl.delitllfy.DelitllfyArrayContext(data, 0, context.config);
                    var instance = $instantiationExpr;
                    switch (arrayContext.closeOrError())
                    {
                        case haxe.ds.Option.None:
                            instance;
                            
                        case haxe.ds.Option.Some(data):
                            litll.core.ds.Result.Err(data);
                    }
            }
		}
	}
    
    // ==============================================================
    // enum
    // ==============================================================
    private function createEnumExpr(constructors:Array<EnumConstructor>):Expr 
	{
        var build = new EnumDelitllfierBuild(builder, dataInterface, parameters, constructors);
        var switchExpr = ExprBuilder.createSwitchExpr(macro context.litll, build.cases);
        return macro return $switchExpr;
	}
    
    // ==============================================================
    // struct
    // ==============================================================
    private function createStructExpr(elements:Array<StructElement>):Expr 
	{
        var build = new StructDelitllfierBuild(builder, dataInterface.path, parameters, elements);
        var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, dataInterface, parameters);
        
        return macro return switch (context.litll)
        {
            case litll.core.Litll.Str(_):
                litll.core.ds.Result.Err(
                    litll.idl.delitllfy.DelitllfyError.ofLitll(
                        context.litll,
                        litll.idl.delitllfy.DelitllfyErrorKind.CantBeString
                    )
                );
                
            case litll.core.Litll.Arr(array):
                $instantiationExpr;
        }
    }
}
