package litll.idl.read.litll;
import litll.core.ds.Result;
import litll.core.parse.Parser;
import litll.core.parse.ParserConfig;
import litll.idl.litll2backend.LitllToEntityConfig;
import litll.idl.litll2backend.LitllToEntityProcessor;

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
