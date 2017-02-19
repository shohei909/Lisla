package litll.project;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Maybe;
import hxext.ds.OrderedMap;
import hxext.ds.Result;
import litll.core.LitllString;
import litll.core.error.ErrorSummary;
import litll.idl.FileError;
import litll.idl.ds.ProcessResult;
import litll.idl.generator.error.IdlReadError;
import litll.idl.hxlitll.litll2entity.config.InputConfigLitllToEntity;
import litll.idl.library.IdlLibrary;
import litll.idl.library.IdlLibraryMap;
import litll.idl.litlltext2entity.LitllFileToEntityRunner;
import litll.idl.litlltext2entity.error.LitllFileToEntityError;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.project.ProjectConfig;
import litll.idl.std.data.util.file.DirectoryPath;
import litll.idl.std.data.util.file.FileExtension;
import sys.FileSystem;
import sys.io.File;

class LitllProject 
{
    public static var LITLL_HOME_VAR:String = "LITLL_HOME";
    
    public var home:Maybe<String>;
    public var description:String;
    public var libraryDirectries(default, null):Array<String>;
    public var extensions(default, null):Map<FileExtension, TypeReference>;
    private var libraries:Maybe<Result<IdlLibraryMap, Array<LitllFileToEntityError>>>;
    
    public function new() 
    {
        var env = Sys.environment();
        home = env.getMaybe(LITLL_HOME_VAR);
        description = "";
        libraryDirectries = [];
        libraries = Maybe.none();
        extensions = new Map();
    }
    
    public function apply(projectHome:String, config:ProjectConfig):Void
    {
        inline function resolvePath(path:String):String
        {
            return Path.normalize(projectHome + "/" + path);
        }
        
        config.litllHome.iter(function (v) home = Maybe.some(resolvePath(v.data)));
        config.description.iter(function (v) description = v.data);
        
        for (idl in config.idl)
        {
            libraryDirectries.push(resolvePath(idl.data));
        }
        for (extension in config.extension)
        {
            extensions.set(extension.target, extension.type);
        }
        
        libraries = Maybe.none();
    }
    
    public function getLibraries():Result<IdlLibraryMap, Array<LitllFileToEntityError>>
    {
        switch libraries.toOption()
        {
            case Option.Some(result):
                return result;
                
            case Option.None:
        }
        
        var map = new IdlLibraryMap();
        var errors = [];
        
        home.iter(function (_home) findLibraries(_home, map, errors));
        
        for (dir in libraryDirectries)
        {
            findLibraries(dir, map, errors);
        }
        
        var result = if (errors.length > 0) Result.Err(errors) else Result.Ok(map);
        libraries = Maybe.some(result);
        return result;
    }
    
    private function findLibraries(file:String, map:IdlLibraryMap, errors:Array<LitllFileToEntityError>):Void
    {
        if (FileSystem.exists(file))
        {
            if (FileSystem.isDirectory(file))
            {
                for (child in FileSystem.readDirectory(file))
                {
                    findLibraries(file + "/" + child, map, errors);
                }
            }
            else if (StringTools.endsWith(file, ".library.litll"))
            {
                var fileName = Path.withoutDirectory(file);
                var name = fileName.substr(0, fileName.length - ".library.litll".length);
                map.read(name, file, errors);
            }
        }
    }
    
    public function generateHaxe(hxinputFilePath:String):Maybe<Array<ErrorSummary>>
    {
        var libraries = switch(getLibraries())
        {
            case Result.Ok(_libraries):
                _libraries;
                
            case Result.Err(errors):
                return Maybe.some(errors.summarize());
        }
        
        var inputConfig = switch (LitllFileToEntityRunner.run(InputConfigLitllToEntity, hxinputFilePath))
        {
            case Result.Ok(_inputConfig):
                _inputConfig;
                
            case Result.Err(errors):
                return Maybe.some(errors.summarize());
        }
        
        return Maybe.none();
    }
}