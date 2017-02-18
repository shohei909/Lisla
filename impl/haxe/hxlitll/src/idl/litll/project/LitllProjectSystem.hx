package litll.project;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Maybe;
import sys.FileSystem;

#if sys
class LitllProjectSystem
{
    private static var MAX_DEPTH = 4096;
    
    public static function getCurrentProject():LitllProject
    {
        return switch (findProjectPath().toOption())
        {
            case Option.Some(path):
                openProject(path);
                
            case Option.None:
                new LitllProject();
        }
    }
    
    public static function findProjectPath():Maybe<String>
    {
        var path = Path.normalize(Sys.getCwd());
        
        for (i in 0...MAX_DEPTH)
        {
            if (path == "") break;
            
            var projectPath = path + "/.project.litll";
            if (FileSystem.exists(projectPath)) return Maybe.some(projectPath);
            
            path = Path.normalize(path + "/..");
        }
        
        return Maybe.none();
    }
    
    public static function openProject(filePath:String):LitllProject
    {
        var project = new LitllProject();
        
        return project;
    }
}
#end
