package litll.project;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.core.parse.Parser;
import litll.idl.litll2entity.LitllToEntityRunner;
import litll.idl.litlltext2entity.LitllFileToEntityRunner;
import litll.idl.litlltext2entity.error.LitllFileToEntityError;
import litll.idl.litlltext2entity.error.LitllFileToEntityErrorKind;
import litll.idl.std.data.idl.project.ProjectConfig;
import litll.idl.std.litll2entity.idl.project.ProjectConfigLitllToEntity;
import sys.FileSystem;
import sys.io.File;

#if sys
class LitllProjectSystem
{
    private static var MAX_DEPTH = 4096;
    
    public static function getCurrentProject():LitllProject
    {
        return switch (findProjectHome().toOption())
        {
            case Option.Some(path):
                openProject(path);
                
            case Option.None:
                new LitllProject();
        }
    }
    
    public static function findProjectHome():Maybe<String>
    {
        var path = Path.normalize(Sys.getCwd());
        
        for (i in 0...MAX_DEPTH)
        {
            if (path == "") break;
            
            var projectPath = path + "/.project.litll";
            if (FileSystem.exists(projectPath)) return Maybe.some(path);
            
            path = Path.normalize(path + "/..");
        }
        
        return Maybe.none();
    }
    
    public static function openProject(projectHome:String):LitllProject
    {
        var project = new LitllProject();
        if (FileSystem.exists(projectHome + "/.project.litll"))
        {
            var config = readProjectConfig(projectHome + "/.project.litll");
        }
        
        return project;
    }
    
    public static function readProjectConfig(filePath:String):Result<ProjectConfig, Array<LitllFileToEntityError>>
    {
        return LitllFileToEntityRunner.run(ProjectConfigLitllToEntity, filePath);
    }
}

#end
