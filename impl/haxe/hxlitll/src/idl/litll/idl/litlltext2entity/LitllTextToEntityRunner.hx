package litll.idl.litlltext2entity;
import hxext.ds.Result;
import litll.core.parse.Parser;
import litll.core.parse.ParserConfig;
import litll.idl.litll2entity.LitllToEntityConfig;
import litll.idl.litll2entity.LitllToEntityRunner;
import litll.idl.litll2entity.LitllToEntityType;
import litll.idl.litlltext2entity.error.LitllTextToEntityErrorKind;

class LitllTextToEntityRunner 
{
	public static function run<T>(processorType:LitllToEntityType<T>, text:String, ?parseConfig:ParserConfig, ?litllToEntityConfig:LitllToEntityConfig):Result<T, Array<LitllTextToEntityErrorKind>>
	{
		var litllArray = switch (Parser.run(text, parseConfig))
        {
            case Result.Ok(data):
                data;
                
            case Result.Err(err):
                var errors = [for (entry in err.entries) LitllTextToEntityErrorKind.Parse(entry)];
                return Result.Err(errors);
        }
        
        return switch (LitllToEntityRunner.run(processorType, litllArray, litllToEntityConfig))
        {
            case Result.Ok(data):
                Result.Ok(data);
                
            case Result.Err(err):
                Result.Err([LitllTextToEntityErrorKind.LitllToEntity(err)]);
        }
	}
}
