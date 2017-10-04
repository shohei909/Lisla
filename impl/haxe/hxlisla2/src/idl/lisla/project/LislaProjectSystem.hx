package arraytree.project;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.data.meta.core.FileData;
import arraytree.project.FilePathFromProjectRoot;
import arraytree.idl.arraytreetext2entity.ArrayTreeFileToEntityRunner;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeFileToEntityError;
import arraytree.idl.std.entity.idl.project.ProjectConfig;
import arraytree.idl.std.arraytree2entity.idl.project.ProjectConfigArrayTreeToEntity;

#if sys
import sys.FileSystem;
import sys.io.File;

class ArrayTreeProjectSystem
{
    private static var MAX_DEPTH = 4096;
    private static var MAIN_PROJECT_FILE_PATH = new FilePathFromProjectRoot("main.project.arraytree");
    private static var USER_PROJECT_FILE_PATH = new FilePathFromProjectRoot("user.project.arraytree");
    
    public static function getCurrentProject():Result<ArrayTreeProject, Array<ArrayTreeFileToEntityError>>
    {
        return switch (findProjectHome().toOption())
        {
            case Option.Some(path):
                openProject(path);
                
            case Option.None:
                Result.Ok(new ArrayTreeProject());
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
    
    public static function openProject(projectHome:ProjectRootDirectory):Result<ArrayTreeProject, Array<ArrayTreeFileToEntityError>>
    {
        var project = new ArrayTreeProject();
        
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
    ):Result<FileData<ProjectConfig>, Array<ArrayTreeFileToEntityError>>
    {
        return ArrayTreeFileToEntityRunner.run(filePath, ProjectConfigArrayTreeToEntity);
    }
}

#end
