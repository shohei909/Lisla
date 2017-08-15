package lisla.project;
import haxe.ds.Option;
import haxe.io.Path;
import hxext.ds.Maybe;
import hxext.ds.Result;
import hxext.error.ErrorBuffer;
import lisla.idl.generator.data.EntityOutputConfig;
import lisla.idl.generator.data.HaxePrintConfig;
import lisla.idl.generator.data.LislaToEntityOutputConfig;
import lisla.idl.generator.output.HaxeGenerateConfigFactory;
import lisla.idl.generator.output.HaxeGenerateConfig;
import lisla.idl.generator.output.HaxeGenerateConfigFactoryContext;
import lisla.idl.generator.output.HaxeGenerator;
import lisla.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import lisla.idl.generator.output.error.GetConfigErrorKind;
import lisla.idl.generator.output.haxe.HaxePrinter;
import lisla.idl.generator.source.IdlFileSourceReader;
import lisla.idl.hxlisla.entity.ImportConfig;
import lisla.idl.hxlisla.lisla2entity.GenerationConfigLislaToEntity;
import lisla.idl.library.LibraryScope;
import lisla.idl.lislatext2entity.LislaFileToEntityRunner;
import lisla.idl.lislatext2entity.error.LislaFileToEntityError;
import lisla.idl.std.entity.idl.TypeReference;
import lisla.idl.std.entity.idl.project.ProjectConfig;
import lisla.idl.std.entity.util.file.FileExtension;
import sys.FileSystem;

class LislaProject
{
    public static var LISLA_HOME_VAR:String = "LISLA_HOME";
    
    public var home:Maybe<String>;
    public var description:String;
    public var libraryDirectries(default, null):Array<String>;
    public var extensions(default, null):Map<FileExtension, TypeReference>;
    private var libraries:Maybe<Result<LibraryScope, Array<LislaFileToEntityError>>>;
    
    public function new() 
    {
        var env = Sys.environment();
        home = env.getMaybe(LISLA_HOME_VAR);
        description = "";
        libraryDirectries = [];
        libraries = Maybe.none();
        extensions = new Map();
    }
    
    public function apply(
        projectHome:ProjectRootDirectory, 
        
        // FIXME: FileData<ProjectConfig>
        config:ProjectConfig
    ):Void
    {
        inline function resolvePath(path:String):String
        {
            return Path.normalize(projectHome + "/" + path);
        }
        
        config.lislaHome.iter(function (v) home = Maybe.some(resolvePath(v.data)));
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
    
    public function getLibraryScope():Result<LibraryScope, Array<LislaFileToEntityError>>
    {
        switch libraries.toOption()
        {
            case Option.Some(result):
                return result;
                
            case Option.None:
        }
        
        var map = new LibraryScope();
        var errors = [];
        
        home.iter(function (_home) findLibraries(_home, map, errors));
        
        for (dir in libraryDirectries)
        {
            findLibraries(dir, map, errors);
        }
        
        var result = if (errors.length > 0) Result.Error(errors) else Result.Ok(map);
        libraries = Maybe.some(result);
        return result;
    }
    
    private function findLibraries(file:String, scope:LibraryScope, errors:Array<LislaFileToEntityError>):Void
    {
        if (FileSystem.exists(file))
        {
            if (FileSystem.isDirectory(file))
            {   
                for (child in FileSystem.readDirectory(file))
                {
                    findLibraries(file + "/" + child, scope, errors);
                }
            }
            else if (StringTools.endsWith(file, ".library.lisla"))
            {
                var fileName = Path.withoutDirectory(file);
                var name = fileName.substr(0, fileName.length - ".library.lisla".length);
                scope.read(name, file, errors);
            }
        }
    }
    
    public function compileIdlToHaxe(
        configFilePath:String, 
        outputDirectory:String,
        configFactoryFunction:HaxeGenerateConfigFactoryContext->HaxeGenerateConfig
    ):Maybe<Array<CompileIdlToHaxeErrorKind>>
    {   
        var config = switch getHaxeGenerationConfig(configFilePath, configFactoryFunction)
        {
            case Result.Error(errors):
                return Maybe.some(errors.map(CompileIdlToHaxeErrorKind.GetConfig));
                 
            case Result.Ok(_config):
                _config;
        }
        
        var types = switch (HaxeGenerator.run(config))
        {
            case Result.Error(errors):
                return Maybe.some(errors.map(CompileIdlToHaxeErrorKind.LoadIdl));
                
            case Result.Ok(_types):
                _types;
        }
        
        var printConfig = new HaxePrintConfig(outputDirectory);
        var printer = new HaxePrinter(printConfig);
        
        return printer.printTypes(types).mapAll(CompileIdlToHaxeErrorKind.Print);
    }
    
    public function getHaxeGenerationConfig(configFilePath:String, configFactoryFunction:HaxeGenerateConfigFactoryContext->HaxeGenerateConfig):Result<HaxeGenerateConfig, Array<GetConfigErrorKind>>
    {
        var errorBuffer = new ErrorBuffer();
        var libraryScope = switch(getLibraryScope())
        {
            case Result.Ok(_libraries):
                _libraries;
                
            case Result.Error(errors):
                errorBuffer.mapAndPushAll(errors, GetConfigErrorKind.GetLibrary);
                null;
        }
        var GenerationConfig = switch (LislaFileToEntityRunner.run(GenerationConfigLislaToEntity, configFilePath))
        {
            case Result.Ok(_GenerationConfig):
                _GenerationConfig;
                
            case Result.Error(errors):
                errorBuffer.mapAndPushAll(errors, GetConfigErrorKind.GetGenerationConfig);
                null;
        }
        
        // error check
        if (errorBuffer.hasError()) return Result.Error(errorBuffer.toArray());
        
        var baseDirectory = Path.directory(configFilePath);
        var requiredGenerationConfigs = [];
        for (imported in GenerationConfig._import)
        {
            switch (imported.data)
            {
                case ImportConfig.File(fileName):
                    var filePath = Path.join([baseDirectory, fileName.data]);
                    switch (LislaFileToEntityRunner.run(GenerationConfigLislaToEntity, filePath))
                    {
                        case Result.Ok(_GenerationConfig):
                            requiredGenerationConfigs.push(_GenerationConfig);
                            
                        case Result.Error(errors):
                            errorBuffer.mapAndPushAll(errors, GetConfigErrorKind.GetGenerationConfig);
                    }
                
                case ImportConfig.Inline(generationConfig):
                    requiredGenerationConfigs.push(generationConfig);
            }
        }
        
        // error check
        return if (errorBuffer.hasError()) 
        {
            Result.Error(errorBuffer.toArray());
        }
        else
        {
            var context = new HaxeGenerateConfigFactoryContext(
                configFilePath,
                libraryScope,
                GenerationConfig,
                requiredGenerationConfigs
            );
            
            Result.Ok(configFactoryFunction(context));
        }
    }
}