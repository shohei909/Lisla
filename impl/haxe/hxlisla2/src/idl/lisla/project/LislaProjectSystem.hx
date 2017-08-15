package lisla.project;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.data.meta.core.FileData;
import lisla.project.FilePathFromProjectRoot;
import lisla.idl.lislatext2entity.LislaFileToEntityRunner;
import lisla.idl.lislatext2entity.error.LislaFileToEntityError;
import lisla.idl.std.entity.idl.project.ProjectConfig;
import lisla.idl.std.lisla2entity.idl.project.ProjectConfigLislaToEntity;

#if sys
import sys.FileSystem;
import sys.io.File;

class LislaProjectSystem
{
    private static var MAX_DEPTH = 4096;
    private static var MAIN_PROJECT_FILE_PATH = new FilePathFromProjectRoot("main.project.lisla");
    private static var USER_PROJECT_FILE_PATH = new FilePathFromProjectRoot("user.project.lisla");
    
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
    
    public static function findProjectHome():Maybe<ProjectRootDirectory>
    {
        var path = new ProjectRootDirectory(Path.normalize(Sys.getCwd()));
        
        for (i in 0...MAX_DEPTH)
        {
            if (path == new ProjectRootDirectory("")) break;
            
            if (path.exists(MAIN_PROJECT_FILE_PATH)) return Maybe.some(path);
            
            path = new ProjectRootDirectory(Path.normalize(path + "/.."));
        }
        
        return Maybe.none();
    }
    
    public static function openProject(projectHome:ProjectRootDirectory):Result<LislaProject, Array<LislaFileToEntityError>>
    {
        var project = new LislaProject();
        
        if (projectHome.exists(MAIN_PROJECT_FILE_PATH))
        {
            switch (readProjectConfig(projectHome.makePair(MAIN_PROJECT_FILE_PATH)))
            {
                case Result.Ok(config):
                    project.apply(projectHome, config.data);
                    
                case Result.Error(errors):
                    return Result.Error(errors);
            }
        }
        
        if (projectHome.exists(USER_PROJECT_FILE_PATH))
        {
            switch (readProjectConfig(projectHome.makePair(USER_PROJECT_FILE_PATH)))
            {
                case Result.Ok(config):
                    project.apply(projectHome, config.data);
                    
                case Result.Error(errors):
                    return Result.Error(errors);
            }
        }
        
        return Result.Ok(project);
    }
    
    public static function readProjectConfig(
        filePath:ProjectRootAndFilePath
    ):Result<FileData<ProjectConfig>, Array<LislaFileToEntityError>>
    {
        return LislaFileToEntityRunner.run(filePath, ProjectConfigLislaToEntity);
    }
}

#end
