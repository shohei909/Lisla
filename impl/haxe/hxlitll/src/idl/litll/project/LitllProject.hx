package litll.project;
import haxe.ds.Option;
import haxe.io.Path;
import haxe.macro.Expr.TypeDefinition;
import hxext.ds.Maybe;
import hxext.ds.Result;
import hxext.error.ErrorBuffer;
import litll.idl.generator.data.EntityOutputConfig;
import litll.idl.generator.data.HaxePrintConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;
import litll.idl.generator.output.IdlToHaxeGenerateContext;
import litll.idl.generator.output.IdlToHaxeGenerator;
import litll.idl.generator.output.error.CompileIdlToHaxeErrorKind;
import litll.idl.generator.output.error.GenerateHaxeErrorKind;
import litll.idl.generator.output.haxe.HaxePrinter;
import litll.idl.hxlitll.litll2entity.config.InputConfigLitllToEntity;
import litll.idl.library.LibraryScope;
import litll.idl.litlltext2entity.LitllFileToEntityRunner;
import litll.idl.litlltext2entity.error.LitllFileToEntityError;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.project.ProjectConfig;
import litll.idl.std.data.util.file.FileExtension;
import sys.FileSystem;

class LitllProject
{
    public static var LITLL_HOME_VAR:String = "LITLL_HOME";
    
    public var home:Maybe<String>;
    public var description:String;
    public var libraryDirectries(default, null):Array<String>;
    public var extensions(default, null):Map<FileExtension, TypeReference>;
    private var libraries:Maybe<Result<LibraryScope, Array<LitllFileToEntityError>>>;
    
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
    
    public function getLibraries():Result<LibraryScope, Array<LitllFileToEntityError>>
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
        
        var result = if (errors.length > 0) Result.Err(errors) else Result.Ok(map);
        libraries = Maybe.some(result);
        return result;
    }
    
    private function findLibraries(file:String, map:LibraryScope, errors:Array<LitllFileToEntityError>):Void
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
    
    public function compileIdlToHaxe(inputFilePath:String, outputDirectory:String):Maybe<Array<CompileIdlToHaxeErrorKind>>
    {
        var types = switch (generateHaxe(inputFilePath))
        {
            case Result.Err(errors):
                return Maybe.some(errors.map(CompileIdlToHaxeErrorKind.Generate));
                
            case Result.Ok(data):
                data;
        }
        
        var printConfig = new HaxePrintConfig(outputDirectory);
        var printer = new HaxePrinter(printConfig);
        
        return printer.printTypes(types).mapAll(CompileIdlToHaxeErrorKind.Print);
    }
    
    public function generateHaxe(inputFilePath:String):Result<Array<TypeDefinition>, Array<GenerateHaxeErrorKind>>
    {
        var errorBuffer = new ErrorBuffer();
        var libraries = switch(getLibraries())
        {
            case Result.Ok(_libraries):
                _libraries;
                
            case Result.Err(errors):
                errorBuffer.mapAndPushAll(errors, GenerateHaxeErrorKind.GetLibrary);
                null;
        }
        var inputConfig = switch (LitllFileToEntityRunner.run(InputConfigLitllToEntity, inputFilePath))
        {
            case Result.Ok(_inputConfig):
                _inputConfig;
                
            case Result.Err(errors):
                errorBuffer.mapAndPushAll(errors, GenerateHaxeErrorKind.GetInputConfig);
                null;
        }
        
        // error check
        if (errorBuffer.hasError()) return Result.Err(errorBuffer.toArray());
        
        var context = new IdlToHaxeGenerateContext(
            this,
            inputFilePath,
            inputConfig,
            libraries
        );
        
        return switch (IdlToHaxeGenerator.run(context))
        {
            case Result.Ok(ok):
                Result.Ok(ok);
                
            case Result.Err(errors):
                Result.Err([for (error in errors) GenerateHaxeErrorKind.LoadIdl(error)]);
        }
    }
}
