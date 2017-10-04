package arraytree.idl.arraytreetext2entity;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.data.meta.core.BlockData;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityConfig;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityRunner;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityType;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeTextToEntityError;
import arraytree.parse.Parser;
import arraytree.parse.ParserConfig;

class ArrayTreeTextToEntityRunner 
{
	public static function run<T>(
        processorType:ArrayTreeToEntityType<T>, 
        text:String, 
        ?parseConfig:ParserConfig, 
        ?arraytreeToEntityConfig:ArrayTreeToEntityConfig
    ):Result<BlockData<T>, Array<ArrayTreeTextToEntityError>>
	{
		var document = switch (Parser.parse(text, parseConfig))
        {
            case Result.Ok(ok):
                ok;
                
            case Result.Error(errors):
                return Result.Error(
                    [for (error in errors) ArrayTreeTextToEntityError.fromParse(error)]
                );
        }
        
        return switch (ArrayTreeToEntityRunner.run(processorType, document.getArrayWithMetadata(), arraytreeToEntityConfig))
        {
            case Result.Ok(data):
                Result.Ok(
                    new BlockData(data, document.metadata, document.sourceMap)
                );
                
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) 
                        ArrayTreeTextToEntityError.fromArrayTreeToEntity(
                            error, 
                            Option.Some(document.sourceMap)
                        )
                    ]
                );
        }
	}
}
