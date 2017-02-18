package litll.idl.read.litll;
import hxext.ds.Result;
import litll.core.parse.Parser;
import litll.core.parse.ParserConfig;
import litll.idl.litll2entity.LitllToEntityConfig;
import litll.idl.litll2entity.LitllToEntityProcessor;

class LitllStringToData
{
    public static function run<T>(
        process:LitllToEntityProcessor<T>, 
        text:String,
        ?parserConfig:ParserConfig,
        ?litllToEntityConfig:LitllToEntityConfig
    ):Result<T, LitllStringToDataErrorKind>
    {
        Parser.run(text, parserConfig);
        
        return null;
    }
}
