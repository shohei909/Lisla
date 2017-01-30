package litll.idl.generator.output.delitll.convert;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefKind;
import litll.core.Litll;
import litll.core.LitllString;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyError;
import litll.idl.exception.IdlException;
import litll.idl.generator.data.DelitllfierOutputConfig;
import litll.idl.generator.output.IdlToHaxeConvertContext;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.delitll.path.HaxeDelitllfierTypePathPair;
import litll.idl.generator.tools.ExprBuilder;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentKind;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorKind;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.GenericTypeReference;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.tools.idl.TypeNameTools;
import litll.idl.std.tools.idl.TypeParameterDeclarationCollection;

import haxe.macro.Expr.TypeDefinition in HaxeTypeDefinition;
import litll.idl.std.data.idl.TypeDefinition in IdlTypeDefinition;

class IdlToHaxeDelitllfierConverter
{
    private var builder:DelitllfierExprBuilder;
	
	private function new (context:IdlToHaxeConvertContext, config:DelitllfierOutputConfig)
	{
		this.builder = new DelitllfierExprBuilder(context, config);
	}
	
	public static function convertType(pathPair:HaxeDelitllfierTypePathPair, source:IdlTypeDefinition, context:IdlToHaxeConvertContext, config:DelitllfierOutputConfig):HaxeTypeDefinition
	{
		return new IdlToHaxeDelitllfierConverter(context, config).run(pathPair, source);
	}
	
	private function run(pathPair:HaxeDelitllfierTypePathPair, source:IdlTypeDefinition):HaxeTypeDefinition
	{
		var parameters:TypeParameterDeclarationCollection;
		var processExpr = switch (source)
		{
			case IdlTypeDefinition.Newtype(name, destType):
                parameters = name.getParameters().collect();
				createNewtypeExpr(pathPair.dataPath, parameters, destType.generalize());
				
			case IdlTypeDefinition.Tuple(name, elements):
				parameters = name.getParameters().collect();
				createTupleExpr(pathPair.dataPath, parameters, elements);
                
			case IdlTypeDefinition.Enum(name, constructors):
				parameters = name.getParameters().collect();
                createEnumExpr(pathPair.dataPath, parameters, constructors);
				
			case IdlTypeDefinition.Struct(name, elements):
				parameters = name.getParameters().collect();
				createStructExpr(pathPair.dataPath, parameters, elements);
		}
        
		var args = [
			{
				name: "context",
				type: (macro : litll.idl.delitllfy.DelitllfyContext)
			}
		];
		for (arg in source.getTypeParameters().toHaxeDelitllfierArgs(builder.context.dataOutputConfig))
		{
			args.push(arg);
		}
        
		var dataTypePath = ComplexType.TPath(
			{
				pack : pathPair.dataPath.getModuleArray(),
				name : pathPair.dataPath.typeName.toString(),
                params : TypeNameTools.toHaxeParams(parameters.parameters)
			}
		);
        
		return {
			pack : pathPair.delitllfierPath.getModuleArray(),
			name : pathPair.delitllfierPath.typeName.toString(),
			params: [], 
			pos : null,
			kind : TypeDefKind.TDClass(null, null, false),
			fields : [
				{
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
			],
		}
	}	

	
    
    // ==============================================================
    // newtype
    // ==============================================================
    private function createNewtypeExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, destType:GenericTypeReference):Expr 
    {
		var callExpr = builder.createProcessCallExpr((macro context), parameters, destType);
		var instantiationExpr = builder.createClassInstantiationExpr((macro context), [], [(macro data)], sourcePath, parameters);
		
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
    private function createTupleExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, elements:Array<TupleElement>):Expr 
	{
        var build = new TupleDelitllfierBuild(builder, parameters, elements);
		var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, sourcePath, parameters);
        
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
    private function createEnumExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, constructors:Array<EnumConstructor>):Expr 
	{
        var build = new EnumDelitllfierBuild(builder, sourcePath, parameters, constructors);
        var switchExpr = ExprBuilder.createSwitchExpr(macro context.litll, build.cases);
        return macro return $switchExpr;
	}
    
    // ==============================================================
    // struct
    // ==============================================================
    private function createStructExpr(sourcePath:HaxeDataTypePath, parameters:TypeParameterDeclarationCollection, elements:Array<StructElement>):Expr 
	{
        var build = new StructDelitllfierBuild(builder, sourcePath, parameters, elements);
        var instantiationExpr = builder.createClassInstantiationExpr((macro context), build.declarations, build.references, sourcePath, parameters);
        
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
