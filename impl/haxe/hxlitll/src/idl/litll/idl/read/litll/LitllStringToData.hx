package litll.idl.read.litll;
import litll.core.ds.Result;
import litll.core.parse.Parser;
import litll.core.parse.ParserConfig;
import litll.idl.delitllfy.DelitllfyConfig;
import litll.idl.delitllfy.DelitllfyProcessor;

class LitllStringToData
{
    public static function run<T>(
        process:DelitllfyProcessor<T>, 
        text:String,
        ?parserConfig:ParserConfig,
        ?delitllfyConfig:DelitllfyConfig
    ):Result<T, LitllStringToDataErrorKind>
    {
        Parser.run(text, parserConfig);
        
        return null;
    }
}
