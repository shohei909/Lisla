package litll.idl.read.litll;
import litll.core.ds.Result;
import litll.core.parse.Parser;
import litll.core.parse.ParserConfig;
import litll.idl.litllToBackend.LitllToBackendConfig;
import litll.idl.litllToBackend.LitllToBackendProcessor;

class LitllStringToData
{
    public static function run<T>(
        process:LitllToBackendProcessor<T>, 
        text:String,
        ?parserConfig:ParserConfig,
        ?litllToBackendConfig:LitllToBackendConfig
    ):Result<T, LitllStringToDataErrorKind>
    {
        Parser.run(text, parserConfig);
        
        return null;
    }
}
