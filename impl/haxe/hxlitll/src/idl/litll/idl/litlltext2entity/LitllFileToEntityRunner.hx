package lisla.idl.lislatext2entity;
import hxext.ds.Result;
import lisla.core.parse.ParserConfig;
import lisla.idl.lisla2entity.LislaToEntityConfig;
import lisla.idl.lisla2entity.LislaToEntityType;
import lisla.idl.lislatext2entity.error.LislaFileToEntityError;
import lisla.idl.lislatext2entity.error.LislaFileToEntityErrorKind;
import sys.FileSystem;
import sys.io.File;

class LislaFileToEntityRunner 
{
    public static function run<T>(processorType:LislaToEntityType<T>, filePath:String, ?parseConfig:ParserConfig, ?lislaToEntityConfig:LislaToEntityConfig):Result<T, Array<LislaFileToEntityError>>
    {
        if (!FileSystem.exists(filePath))
        {
            return Result.Err([new LislaFileToEntityError(filePath, LislaFileToEntityErrorKind.FileNotFound)]);
        }
        
        var text = File.getContent(filePath);
        return switch (LislaTextToEntityRunner.run(processorType, text, parseConfig, lislaToEntityConfig))
        {
            case Result.Ok(data):
                Result.Ok(data);
                
            case Result.Err(errors):
                Result.Err([for (err in errors) new LislaFileToEntityError(filePath, LislaFileToEntityErrorKind.LislaTextToEntity(err))]);
        }
    }
}
