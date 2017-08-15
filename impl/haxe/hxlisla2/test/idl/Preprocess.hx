import haxe.io.Path;
import hxext.ds.Result;
import lisla.idl.generator.io.StandardIoProvider;
import lisla.idl.generator.output.HaxeGenerateConfigFactory;
import lisla.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import lisla.project.LislaProjectSystem;
import lisla.project.error.HxlislaErrorKind;
import sys.FileSystem;
using hxext.ds.ResultTools;

class Preprocess 
{
    public static function main():Void
    {
        remove("migration/lisla");
        
        // new
        var lislaProject = switch (LislaProjectSystem.getCurrentProject())
        {
            case Result.Ok(lislaProject):
                lislaProject;
                
            case Result.Error(errors):
                outputErrorAndClose(errors, HxlislaErrorKind.LoadProject);
                return;
        }
        
        lislaProject.compileIdlToHaxe(
            "lisla/hxlisla/lisla.hxgen.lisla", 
            "migration",
            new LislaHaxeGenerateConfigFactory().create
        ).iter(outputCompileIdlToHaxeErrorAndClose);
        
        lislaProject.compileIdlToHaxe(
            "lisla/hxlisla/hxlisla.hxgen.lisla", 
            "migration",
            new HxlislaHaxeGenerateConfigFactory().create
        ).iter(outputCompileIdlToHaxeErrorAndClose);
    }
    
    private static function outputCompileIdlToHaxeErrorAndClose(errors:Array<CompileIdlToHaxeErrorKind>):Void
    {
        outputErrorAndClose(errors, HxlislaErrorKind.CompileIdlToHaxe);
    }
    
    private inline static function outputErrorAndClose<Kind>(errors:Array<Kind>, func:Kind->HxlislaErrorKind):Void
    {
        var io = new StandardIoProvider();
        for (error in errors)
        {
            var summary = HxlislaErrorKindTools.getSummary(func(error));
            io.printErrorLine(summary.toString());
        }
        
        Sys.exit(1);
    }
    
	private static function remove(file:String):Void 
	{
		if (FileSystem.exists(file)) 
		{
			if (FileSystem.isDirectory(file)) 
			{
				for (item in FileSystem.readDirectory(file)) 
				{
					item = Path.join([file, item]);
					remove(item);
				}
				FileSystem.deleteDirectory(file);
			} 
			else
			{
				FileSystem.deleteFile(file);
			}
		}
	} 
}

private class LislaHaxeGenerateConfigFactory extends HaxeGenerateConfigFactory
{
}

private class HxlislaHaxeGenerateConfigFactory extends HaxeGenerateConfigFactory
{
}
