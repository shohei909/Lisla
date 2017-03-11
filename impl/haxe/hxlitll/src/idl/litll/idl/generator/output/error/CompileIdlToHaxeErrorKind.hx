package litll.idl.generator.output.error;
import litll.idl.generator.output.error.GenerateHaxeErrorKind;
import litll.idl.generator.output.haxe.PrintHaxeErrorKind;

enum CompileIdlToHaxeErrorKind 
{
    Generate(error:GenerateHaxeErrorKind);
    Print(error:PrintHaxeErrorKind);
}
