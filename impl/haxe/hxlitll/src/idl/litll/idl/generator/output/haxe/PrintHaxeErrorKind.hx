package litll.idl.generator.output.haxe;

enum PrintHaxeErrorKind 
{
    OutputDirectoryNotFound(directory:String);
    IsNotDirectory(path:String);
}
