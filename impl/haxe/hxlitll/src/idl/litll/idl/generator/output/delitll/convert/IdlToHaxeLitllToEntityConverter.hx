package litll.idl.generator.output.delitll.convert;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import litll.core.Litll;
import hxext.ds.Result;
import litll.idl.litll2entity.LitllToEntityArrayContext;
import litll.idl.litll2entity.LitllToEntityContext;
import litll.idl.litll2entity.error.LitllToEntityError;
import litll.idl.generator.data.LitllToEntityOutputConfig;
import litll.idl.generator.output.IdlToHaxeConvertContext;
import litll.idl.generator.output.data.store.HaxeDataInterface;
import litll.idl.generator.output.delitll.path.HaxeLitllToEntityTypePathPair;
import litll.idl.generator.source.validate.InlinabilityOnTuple;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.litll2entity.error.LitllToEntityErrorKind;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.tools.idl.TypeNameTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;

class IdlToHaxeLitllToEntityConverter
{
    private var builder:LitllToEntityExprBuilder;
    
    private var pathPair:HaxeLitllToEntityTypePathPair;
    private var addtionalArgs:Array<FunctionArg>;
    private var dataTypePath:ComplexType;
	private var dataInterface:HaxeDataInterface;
    private var parameters:TypeParameterDeclarationCollection;
    private var definition:IdlTypeDefinition;
    
	private function new (context:IdlToHaxeConvertContext, config:LitllToEntityOutputConfig)
	{
		this.builder = new LitllToEntityExprBuilder(context, config);
	}
	
	public static function convertType(pathPair:HaxeLitllToEntityTypePathPair, context:IdlToHaxeConvertContext, config:LitllToEntityOutputConfig):HaxeTypeDefinition
	{
		return new IdlToHaxeLitllToEntityConverter(context, config).run(pathPair);
	}
	
	private function run(pathPair:HaxeLitllToEntityTypePathPair):HaxeTypeDefinition
	{
        this.pathPair = pathPair;
        this.definition = pathPair.typeInfo.definition;
        var typeParameters = pathPair.typeInfo.definition.getTypeParameters();
        this.parameters = typeParameters.collect();
        
        this.addtionalArgs = typeParameters.toHaxeLitllToEntityArgs(builder.context.dataOutputConfig);
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
                fields.push(createFixedInlineProcessFunction());
                
            case InlinabilityOnTuple.Always:
                fields.push(createFixedInlineProcessFunction());
                fields.push(createVariableInlineProcessFunction());
        }
        
		return {
			pack : pathPair.litllToEntityPath.getModuleArray(),
			name : pathPair.litllToEntityPath.typeName.toString(),
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
				type: (macro : litll.idl.litll2entity.LitllToEntityContext)
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
                    ret: macro:hxext.ds.Result<$dataTypePath, litll.idl.litll2entity.error.LitllToEntityError>,
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
                macro return null;
				
			case IdlTypeDefinition.Tuple(name, elements):
				macro return null;
                
			case IdlTypeDefinition.Enum(name, constructors):
		        macro return null;
				
			case IdlTypeDefinition.Struct(name, elements):
				macro return null;
		}
        
		var args = [
			{
				name: "context",
				type: (macro : litll.idl.litll2entity.LitllToEntityArrayContext)
			}
		].concat(addtionalArgs);
        
        return {
            name : "fixedInlineProcess",
            kind : FieldType.FFun(
                {
                    args: args,
                    ret: macro:hxext.ds.Result<$dataTypePath, litll.idl.litll2entity.error.LitllToEntityError>,
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
                macro return null;
				
			case IdlTypeDefinition.Tuple(name, elements):
				macro return null;
                
			case IdlTypeDefinition.Enum(name, constructors):
		        macro return null;
				
			case IdlTypeDefinition.Struct(name, elements):
				macro return null;
		}
        
		var args = [
			{
				name: "context",
				type: (macro : litll.idl.litll2entity.LitllToEntityArrayContext)
			}
		].concat(addtionalArgs);
        
		for (arg in addtionalArgs)
		{
			args.push(arg);
		}
        
        return {
            name : "variableInlineProcess",
            kind : FieldType.FFun(
                {
                    args: args,
                    ret: macro:hxext.ds.Result<$dataTypePath, litll.idl.litll2entity.error.LitllToEntityError>,
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
				case hxext.ds.Result.Ok(data):
					$instantiationExpr;
					
				case hxext.ds.Result.Err(data):
					hxext.ds.Result.Err(data);
			}
		}
	}
    
    // ==============================================================
    // tuple
    // ==============================================================
    private function createTupleExpr(elements:Array<TupleElement>):Expr 
	{
        var build = new TupleLitllToEntityBuild(builder, parameters, elements);
		var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, dataInterface, parameters);
        
        return macro {
            return switch (context.litll)
            {
                case litll.core.Litll.Str(_):
                    hxext.ds.Result.Err(
                        litll.idl.litll2entity.error.LitllToEntityError.ofLitll(
                            context.litll,
                            litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString
                        )
                    );
                    
                case litll.core.Litll.Arr(data):
                    var arrayContext = new litll.idl.litll2entity.LitllToEntityArrayContext(data, 0, context.config);
                    var instance = $instantiationExpr;
                    switch (arrayContext.closeOrError())
                    {
                        case haxe.ds.Option.None:
                            instance;
                            
                        case haxe.ds.Option.Some(data):
                            hxext.ds.Result.Err(data);
                    }
            }
		}
	}
    
    // ==============================================================
    // enum
    // ==============================================================
    private function createEnumExpr(constructors:Array<EnumConstructor>):Expr 
	{
        var build = new EnumLitllToEntityBuild(builder, dataInterface, parameters, constructors);
        var switchExpr = ExprBuilder.createSwitchExpr(macro context.litll, build.cases);
        return macro return $switchExpr;
	}
    
    // ==============================================================
    // struct
    // ==============================================================
    private function createStructExpr(elements:Array<StructElement>):Expr 
	{
        var build = new StructLitllToEntityBuild(builder, dataInterface.path, parameters, elements);
        var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, dataInterface, parameters);
        
        return macro return switch (context.litll)
        {
            case litll.core.Litll.Str(_):
                hxext.ds.Result.Err(
                    litll.idl.litll2entity.error.LitllToEntityError.ofLitll(
                        context.litll,
                        litll.idl.litll2entity.error.LitllToEntityErrorKind.CantBeString
                    )
                );
                
            case litll.core.Litll.Arr(array):
                $instantiationExpr;
        }
    }
}
