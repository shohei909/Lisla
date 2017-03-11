package lisla.idl.lislatext2entity;
import hxext.ds.Result;
import lisla.core.parse.Parser;
import lisla.core.parse.ParserConfig;
import lisla.idl.lisla2entity.LislaToEntityConfig;
import lisla.idl.lisla2entity.LislaToEntityRunner;
import lisla.idl.lisla2entity.LislaToEntityType;
import lisla.idl.lislatext2entity.error.LislaTextToEntityErrorKind;

class LislaTextToEntityRunner 
{
	public static function run<T>(processorType:LislaToEntityType<T>, text:String, ?parseConfig:ParserConfig, ?lislaToEntityConfig:LislaToEntityConfig):Result<T, Array<LislaTextToEntityErrorKind>>
	{
		var lislaArray = switch (Parser.run(text, parseConfig))
        {
            case Result.Ok(data):
                data;
                
            case Result.Err(err):
                var errors = [for (entry in err.entries) LislaTextToEntityErrorKind.Parse(entry)];
                return Result.Err(errors);
        }
        
        return switch (LislaToEntityRunner.run(processorType, lislaArray, lislaToEntityConfig))
        {
            case Result.Ok(data):
                Result.Ok(data);
                
            case Result.Err(err):
                Result.Err([LislaTextToEntityErrorKind.LislaToEntity(err)]);
        }
	}
}
