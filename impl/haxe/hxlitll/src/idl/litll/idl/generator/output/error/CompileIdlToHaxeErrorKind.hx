package litll.idl.generator.output.error;
import litll.idl.generator.error.LoadIdlError;
import litll.idl.generator.output.error.GetConfigErrorKind;
import litll.idl.generator.output.haxe.PrintHaxeErrorKind;

enum CompileIdlToHaxeErrorKind 
{
    GetConfig(error:GetConfigErrorKind);
    LoadIdl(error:LoadIdlError);
    Print(error:PrintHaxeErrorKind);
}
