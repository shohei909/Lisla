package litll.idl.generator.output.error;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.output.error.GetConfigErrorKind;
import litll.idl.generator.output.haxe.PrintHaxeErrorKind;

enum CompileIdlToHaxeErrorKind 
{
    GetConfig(error:GetConfigErrorKind);
    LoadIdl(error:ReadIdlError);
    Print(error:PrintHaxeErrorKind);
}
