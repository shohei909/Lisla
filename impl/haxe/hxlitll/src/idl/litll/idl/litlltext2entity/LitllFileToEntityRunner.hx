package litll.idl.litlltext2entity;
import hxext.ds.Result;
import litll.core.parse.ParserConfig;
import litll.idl.litll2entity.LitllToEntityConfig;
import litll.idl.litll2entity.LitllToEntityType;
import litll.idl.litlltext2entity.error.LitllFileToEntityError;
import litll.idl.litlltext2entity.error.LitllFileToEntityErrorKind;
import sys.FileSystem;
import sys.io.File;

class LitllFileToEntityRunner 
{
    public static function run<T>(processorType:LitllToEntityType<T>, filePath:String, ?parseConfig:ParserConfig, ?litllToEntityConfig:LitllToEntityConfig):Result<T, Array<LitllFileToEntityError>>
    {
        if (!FileSystem.exists(filePath))
        {
            return Result.Err([new LitllFileToEntityError(filePath, LitllFileToEntityErrorKind.FileNotFound)]);
        }
        
        var text = File.getContent(filePath);
        return switch (LitllTextToEntityRunner.run(processorType, text, parseConfig, litllToEntityConfig))
        {
            case Result.Ok(data):
                Result.Ok(data);
                
            case Result.Err(errors):
                Result.Err([for (err in errors) new LitllFileToEntityError(filePath, LitllFileToEntityErrorKind.LitllTextToEntity(err))]);
        }
    }
}
