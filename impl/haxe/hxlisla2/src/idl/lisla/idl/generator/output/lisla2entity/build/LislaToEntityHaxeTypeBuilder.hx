package arraytree.idl.generator.output.arraytree2entity.build;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import hxext.ds.Result;
import arraytree.data.tree.al.AlTree;
import arraytree.idl.generator.data.ArrayTreeToEntityOutputConfig;
import arraytree.idl.generator.output.HaxeConvertContext;
import arraytree.idl.generator.output.entity.store.HaxeEntityInterface;
import arraytree.idl.generator.output.arraytree2entity.path.HaxeArrayTreeToEntityTypePathPair;
import arraytree.idl.generator.source.validate.InlinabilityOnTuple;
import arraytree.idl.generator.tools.ExprBuilder;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityArrayContext;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityContext;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
import arraytree.idl.std.entity.idl.EnumConstructor;
import arraytree.idl.std.entity.idl.GenericTypeReference;
import arraytree.idl.std.entity.idl.StructElement;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.tools.idl.TypeNameTools;
import arraytree.idl.std.tools.idl.TypeParameterDeclarationCollection;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import arraytree.idl.std.entity.idl.TypeDefinition in IdlTypeDefinition;

class ArrayTreeToEntityHaxeTypeBuilder
{
    private var builder:ArrayTreeToEntityExprBuilder;
    
    private var pathPair:HaxeArrayTreeToEntityTypePathPair;
    private var addtionalArgs:Array<FunctionArg>;
    private var dataTypePath:ComplexType;
	private var dataInterface:HaxeEntityInterface;
    private var parameters:TypeParameterDeclarationCollection;
    private var definition:IdlTypeDefinition;
    
	private function new (context:HaxeConvertContext)
	{
		this.builder = new ArrayTreeToEntityExprBuilder(context);
	}
	
	public static function convertType(pathPair:HaxeArrayTreeToEntityTypePathPair, context:HaxeConvertContext):HaxeTypeDefinition
	{
		return new ArrayTreeToEntityHaxeTypeBuilder(context).run(pathPair);
	}
	
	private function run(pathPair:HaxeArrayTreeToEntityTypePathPair):HaxeTypeDefinition
	{
        this.pathPair = pathPair;
        this.definition = pathPair.typeInfo.definition;
        var typeParameters = pathPair.typeInfo.definition.getTypeParameters();
        this.parameters = typeParameters.collect();
        
        this.addtionalArgs = typeParameters.toHaxeArrayTreeToEntityArgs(builder.context.entityOutputConfig);
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
			pack : pathPair.arraytreeToEntityPath.getModuleArray(),
			name : pathPair.arraytreeToEntityPath.typeName.toString(),
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
				type: (macro : arraytree.idl.arraytree2entity.ArrayTreeToEntityContext)
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
                    ret: macro:hxext.ds.Result<$dataTypePath, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>>,
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
				type: (macro : arraytree.idl.arraytree2entity.ArrayTreeToEntityArrayContext)
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
                    ret: macro:hxext.ds.Result<$dataTypePath, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>>,
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
        var build = new TupleArrayTreeToEntityBuild(builder, parameters, elements);
		var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, dataInterface, parameters);
        
        return macro {
            return switch (context.arraytree.kind)
            {
                case arraytree.data.tree.al.AlTreeKind.Leaf(_):
                    hxext.ds.Result.Error(
                        arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError.ofArrayTree(
                            context.arraytree,
                            arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind.CantBeString
                        )
                    );
                    
                case arraytree.data.tree.al.AlTreeKind.Arr(array):
                    var arrayContext = new arraytree.idl.arraytree2entity.ArrayTreeToEntityArrayContext(array, 0, context.config);
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
        var build = new EnumArrayTreeToEntityBuild(builder, dataInterface, parameters, constructors);
        var switchExpr = ExprBuilder.createSwitchExpr(macro context.arraytree, build.cases);
        return macro return $switchExpr;
	}
    // ==============================================================
    // struct
    // ==============================================================
    private function createStructExpr(elements:Array<StructElement>):Expr 
	{
        var build = new StructArrayTreeToEntityBuild(builder, dataInterface.path, parameters, elements);
        var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, dataInterface, parameters);
        
        return macro return switch (context.arraytree.kind)
        {
            case arraytree.data.tree.al.AlTreeKind.Leaf(_):
                hxext.ds.Result.Error(
                    arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError.ofArrayTree(
                        context.arraytree,
                        arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind.CantBeString
                    )
                );
                
            case arraytree.data.tree.al.AlTreeKind.Arr(array):
                $instantiationExpr;
        }
    }
}
