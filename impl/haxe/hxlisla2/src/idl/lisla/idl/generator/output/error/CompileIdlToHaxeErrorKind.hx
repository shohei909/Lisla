package lisla.idl.generator.output.error;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.output.error.GetConfigErrorKind;
import lisla.idl.generator.output.haxe.PrintHaxeErrorKind;

enum CompileIdlToHaxeErrorKind 
{
    GetConfig(error:GetConfigErrorKind);
    LoadIdl(error:LoadIdlError);
    Print(error:PrintHaxeErrorKind);
}
