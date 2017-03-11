package lisla.idl.generator.source.file;

abstract IdlFilePath(String) to String 
{
    public function new (file:String)
    {
        this = file;
    }
}
