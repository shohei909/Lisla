import haxe.io.Path;
import hxext.ds.Result;
import arraytree.idl.generator.io.StandardIoProvider;
import arraytree.idl.generator.output.HaxeGenerateConfigFactory;
import arraytree.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import arraytree.project.ArrayTreeProjectSystem;
import arraytree.project.error.HxarraytreeErrorKind;
import sys.FileSystem;
using hxext.ds.ResultTools;

class Preprocess 
{
    public static function main():Void
    {
        remove("migration/arraytree");
        
        // new
        var arraytreeProject = switch (ArrayTreeProjectSystem.getCurrentProject())
        {
            case Result.Ok(arraytreeProject):
                arraytreeProject;
                
            case Result.Error(errors):
                outputErrorAndClose(errors, HxarraytreeErrorKind.LoadProject);
                return;
        }
        
        arraytreeProject.compileIdlToHaxe(
            "arraytree/hxarraytree/arraytree.hxgen.arraytree", 
            "migration",
            new ArrayTreeHaxeGenerateConfigFactory().create
        ).iter(outputCompileIdlToHaxeErrorAndClose);
        
        arraytreeProject.compileIdlToHaxe(
            "arraytree/hxarraytree/hxarraytree.hxgen.arraytree", 
            "migration",
            new HxarraytreeHaxeGenerateConfigFactory().create
        ).iter(outputCompileIdlToHaxeErrorAndClose);
    }
    
    private static function outputCompileIdlToHaxeErrorAndClose(errors:Array<CompileIdlToHaxeErrorKind>):Void
    {
        outputErrorAndClose(errors, HxarraytreeErrorKind.CompileIdlToHaxe);
    }
    
    private inline static function outputErrorAndClose<Kind>(errors:Array<Kind>, func:Kind->HxarraytreeErrorKind):Void
    {
        var io = new StandardIoProvider();
        for (error in errors)
        {
            var summary = HxarraytreeErrorKindTools.getSummary(func(error));
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

private class ArrayTreeHaxeGenerateConfigFactory extends HaxeGenerateConfigFactory
{
}

private class HxarraytreeHaxeGenerateConfigFactory extends HaxeGenerateConfigFactory
{
}
