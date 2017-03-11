import haxe.io.Path;
import hxext.ds.Result;
import litll.idl.generator.io.StandardIoProvider;
import litll.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import litll.project.LitllProjectSystem;
import litll.project.error.HxlitllErrorKind;
import litll.project.error.HxlitllErrorKindTools;
import sys.FileSystem;
using hxext.ds.ResultTools;

class Preprocess 
{
    public static function main():Void
    {
        remove("migration/litll");
        
        // new
        var litllProject = switch (LitllProjectSystem.getCurrentProject())
        {
            case Result.Ok(litllProject):
                litllProject;
                
            case Result.Err(errors):
                outputErrorAndClose(errors, HxlitllErrorKind.LoadProject);
                return;
        }
        
        litllProject.compileIdlToHaxe("litll/hxlitll/litll.hxinput.litll", "migration").iter(outputCompileIdlToHaxeErrorAndClose);
        litllProject.compileIdlToHaxe("litll/hxlitll/hxlitll.hxinput.litll", "migration").iter(outputCompileIdlToHaxeErrorAndClose);
    }
    
    private static function outputCompileIdlToHaxeErrorAndClose(errors:Array<CompileIdlToHaxeErrorKind>):Void
    {
        outputErrorAndClose(errors, HxlitllErrorKind.CompileIdlToHaxe);
    }
    
    private inline static function outputErrorAndClose<Kind>(errors:Array<Kind>, func:Kind->HxlitllErrorKind):Void
    {
        var io = new StandardIoProvider();
        for (error in errors)
        {
            var summary = HxlitllErrorKindTools.getSummary(func(error));
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
