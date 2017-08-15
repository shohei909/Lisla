package lisla.idl.generator.output.lisla2entity.build;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import hxext.ds.Result;
import lisla.data.tree.al.AlTree;
import lisla.idl.generator.data.LislaToEntityOutputConfig;
import lisla.idl.generator.output.HaxeConvertContext;
import lisla.idl.generator.output.entity.store.HaxeEntityInterface;
import lisla.idl.generator.output.lisla2entity.path.HaxeLislaToEntityTypePathPair;
import lisla.idl.generator.source.validate.InlinabilityOnTuple;
import lisla.idl.generator.tools.ExprBuilder;
import lisla.idl.lisla2entity.LislaToEntityArrayContext;
import lisla.idl.lisla2entity.LislaToEntityContext;
import lisla.idl.lisla2entity.error.LislaToEntityError;
import lisla.idl.lisla2entity.error.LislaToEntityErrorKind;
import lisla.idl.std.entity.idl.EnumConstructor;
import lisla.idl.std.entity.idl.GenericTypeReference;
import lisla.idl.std.entity.idl.StructElement;
import lisla.idl.std.entity.idl.TupleElement;
import lisla.idl.std.tools.idl.TypeNameTools;
import lisla.idl.std.tools.idl.TypeParameterDeclarationCollection;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import lisla.idl.std.entity.idl.TypeDefinition in IdlTypeDefinition;

class LislaToEntityHaxeTypeBuilder
{
    private var builder:LislaToEntityExprBuilder;
    
    private var pathPair:HaxeLislaToEntityTypePathPair;
    private var addtionalArgs:Array<FunctionArg>;
    private var dataTypePath:ComplexType;
	private var dataInterface:HaxeEntityInterface;
    private var parameters:TypeParameterDeclarationCollection;
    private var definition:IdlTypeDefinition;
    
	private function new (context:HaxeConvertContext)
	{
		this.builder = new LislaToEntityExprBuilder(context);
	}
	
	public static function convertType(pathPair:HaxeLislaToEntityTypePathPair, context:HaxeConvertContext):HaxeTypeDefinition
	{
		return new LislaToEntityHaxeTypeBuilder(context).run(pathPair);
	}
	
	private function run(pathPair:HaxeLislaToEntityTypePathPair):HaxeTypeDefinition
	{
        this.pathPair = pathPair;
        this.definition = pathPair.typeInfo.definition;
        var typeParameters = pathPair.typeInfo.definition.getTypeParameters();
        this.parameters = typeParameters.collect();
        
        this.addtionalArgs = typeParameters.toHaxeLislaToEntityArgs(builder.context.entityOutputConfig);
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
                
            case InlinabilityOnTuple.Always:
                fields.push(createVariableInlineProcessFunction());
        }
        
		return {
			pack : pathPair.lislaToEntityPath.getModuleArray(),
			name : pathPair.lislaToEntityPath.typeName.toString(),
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
				type: (macro : lisla.idl.lisla2entity.LislaToEntityContext)
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
                    ret: macro:hxext.ds.Result<$dataTypePath, Array<lisla.idl.lisla2entity.error.LislaToEntityError>>,
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
				name: "arrayContext",
				type: (macro : lisla.idl.lisla2entity.LislaToEntityArrayContext)
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
                    ret: macro:hxext.ds.Result<$dataTypePath, Array<lisla.idl.lisla2entity.error.LislaToEntityError>>,
                    expr: processExpr,
                    params : TypeNameTools.toHaxeParamDecls(parameters.parameters),
                }
            ),
            access: [Access.APublic, Access.AStatic],
            pos: null,
        }
    }
    
    // --------------------------------------------------------------
    // process expr
    // --------------------------------------------------------------
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
					
				case hxext.ds.Result.Error(data):
					hxext.ds.Result.Error(data);
			}
		}
	}
    // ==============================================================
    // tuple
    // ==============================================================
    private function createTupleExpr(elements:Array<TupleElement>):Expr 
	{
        var build = new TupleLislaToEntityBuild(builder, parameters, elements);
		var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, dataInterface, parameters);
        
        return macro {
            return switch (context.lisla.kind)
            {
                case lisla.data.tree.al.AlTreeKind.Leaf(_):
                    hxext.ds.Result.Error(
                        lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(
                            context.lisla,
                            lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString
                        )
                    );
                    
                case lisla.data.tree.al.AlTreeKind.Arr(array):
                    var arrayContext = new lisla.idl.lisla2entity.LislaToEntityArrayContext(array, 0, context.config);
                    var instance = $instantiationExpr;
                    switch (arrayContext.closeOrError())
                    {
                        case haxe.ds.Option.None:
                            instance;
                            
                        case haxe.ds.Option.Some(data):
                            hxext.ds.Result.Error(data);
                    }
            }
		}
	}
    // ==============================================================
    // enum
    // ==============================================================
    private function createEnumExpr(constructors:Array<EnumConstructor>):Expr 
	{
        var build = new EnumLislaToEntityBuild(builder, dataInterface, parameters, constructors);
        var switchExpr = ExprBuilder.createSwitchExpr(macro context.lisla, build.cases);
        return macro return $switchExpr;
	}
    // ==============================================================
    // struct
    // ==============================================================
    private function createStructExpr(elements:Array<StructElement>):Expr 
	{
        var build = new StructLislaToEntityBuild(builder, dataInterface.path, parameters, elements);
        var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, dataInterface, parameters);
        
        return macro return switch (context.lisla.kind)
        {
            case lisla.data.tree.al.AlTreeKind.Leaf(_):
                hxext.ds.Result.Error(
                    lisla.idl.lisla2entity.error.LislaToEntityError.ofLisla(
                        context.lisla,
                        lisla.idl.lisla2entity.error.LislaToEntityErrorKind.CantBeString
                    )
                );
                
            case lisla.data.tree.al.AlTreeKind.Arr(array):
                $instantiationExpr;
        }
    }
}
