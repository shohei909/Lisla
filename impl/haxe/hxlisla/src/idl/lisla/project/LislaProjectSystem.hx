package lisla.project;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.core.parse.Parser;
import lisla.idl.lisla2entity.LislaToEntityRunner;
import lisla.idl.lislatext2entity.LislaFileToEntityRunner;
import lisla.idl.lislatext2entity.error.LislaFileToEntityError;
import lisla.idl.lislatext2entity.error.LislaFileToEntityErrorKind;
import lisla.idl.std.entity.idl.project.ProjectConfig;
import lisla.idl.std.lisla2entity.idl.project.ProjectConfigLislaToEntity;
import sys.FileSystem;
import sys.io.File;

#if sys
class LislaProjectSystem
{
    private static var MAX_DEPTH = 4096;
    
    public static function getCurrentProject():Result<LislaProject, Array<LislaFileToEntityError>>
    {
        return switch (findProjectHome().toOption())
        {
            case Option.Some(path):
                openProject(path);
                
            case Option.None:
                Result.Ok(new LislaProject());
        }
    }
    
    public static function findProjectHome():Maybe<String>
    {
        var path = Path.normalize(Sys.getCwd());
        
        for (i in 0...MAX_DEPTH)
        {
            if (path == "") break;
            
            var projectPath = path + "/main.project.lisla";
            if (FileSystem.exists(projectPath)) return Maybe.some(path);
            
            path = Path.normalize(path + "/..");
        }
        
        return Maybe.none();
    }
    
    public static function openProject(projectHome:String):Result<LislaProject, Array<LislaFileToEntityError>>
    {
        var project = new LislaProject();
        
        if (FileSystem.exists(projectHome + "/main.project.lisla"))
        {
            switch (readProjectConfig(projectHome + "/main.project.lisla"))
            {
                case Result.Ok(config):
                    project.apply(projectHome, config);
                    
                case Result.Err(errors):
                    return Result.Err(errors);
            }
        }
        if (FileSystem.exists(projectHome + "/user.project.lisla"))
        {
            switch (readProjectConfig(projectHome + "/user.project.lisla"))
            {
                case Result.Ok(config):
                    project.apply(projectHome, config);
                    
                case Result.Err(errors):
                    return Result.Err(errors);
            }
        }
        
        return Result.Ok(project);
    }
    
    public static function readProjectConfig(filePath:String):Result<ProjectConfig, Array<LislaFileToEntityError>>
    {
        return LislaFileToEntityRunner.run(ProjectConfigLislaToEntity, filePath);
    }
}

#end
