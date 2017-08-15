package lisla.idl.lislatext2entity;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.data.meta.core.BlockData;
import lisla.idl.lisla2entity.LislaToEntityConfig;
import lisla.idl.lisla2entity.LislaToEntityRunner;
import lisla.idl.lisla2entity.LislaToEntityType;
import lisla.idl.lislatext2entity.error.LislaTextToEntityError;
import lisla.parse.Parser;
import lisla.parse.ParserConfig;

class LislaTextToEntityRunner 
{
	public static function run<T>(
        processorType:LislaToEntityType<T>, 
        text:String, 
        ?parseConfig:ParserConfig, 
        ?lislaToEntityConfig:LislaToEntityConfig
    ):Result<BlockData<T>, Array<LislaTextToEntityError>>
	{
		var document = switch (Parser.parse(text, parseConfig))
        {
            case Result.Ok(ok):
                ok;
                
            case Result.Error(errors):
                return Result.Error(
                    [for (error in errors) LislaTextToEntityError.fromParse(error)]
                );
        }
        
        return switch (LislaToEntityRunner.run(processorType, document.getArrayWithMetadata(), lislaToEntityConfig))
        {
            case Result.Ok(data):
                Result.Ok(
                    new BlockData(data, document.metadata, document.sourceMap)
                );
                
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) 
                        LislaTextToEntityError.fromLislaToEntity(
                            error, 
                            Option.Some(document.sourceMap)
                        )
                    ]
                );
        }
	}
}
