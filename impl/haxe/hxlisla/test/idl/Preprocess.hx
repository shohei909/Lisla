import lisla.idl.code.generate.HaxeGenerator;
using hxext.ds.ResultTools;

class Preprocess 
{
    public static function main():Void
    {
        HaxeGenerator.run(
            MinimalIdl.getLibrary()
        );
    }
}
