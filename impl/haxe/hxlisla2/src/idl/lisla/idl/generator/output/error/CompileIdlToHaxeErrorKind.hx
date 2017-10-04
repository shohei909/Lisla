package arraytree.idl.generator.output.error;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.output.error.GetConfigErrorKind;
import arraytree.idl.generator.output.haxe.PrintHaxeErrorKind;

enum CompileIdlToHaxeErrorKind 
{
    GetConfig(error:GetConfigErrorKind);
    LoadIdl(error:LoadIdlError);
    Print(error:PrintHaxeErrorKind);
}
