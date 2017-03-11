package litll.idl.generator.output;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.idl.exception.ConversionExeption;
import litll.idl.exception.IdlException;
import litll.idl.generator.data.EntityOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.library.LibraryResolver;
import litll.idl.library.LoadTypesContext;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;

class IdlToHaxeConvertContext implements IdlSourceProvider
{
    public var libraryResolver(default, null):LibraryResolver;
    public var entityOutputConfig(default, null):EntityOutputConfig;
    public var litllToEntityConfig(default, null):LitllToEntityOutputConfig;
    
    public function new(
        libraryResolver:LibraryResolver, 
        entityOutputConfig:EntityOutputConfig,
        litllToEntityConfig:LitllToEntityOutputConfig
    )
    {
        this.litllToEntityConfig = litllToEntityConfig;
        this.libraryResolver = libraryResolver;
        this.entityOutputConfig = entityOutputConfig;
    }
    
    public function resolveTypePath(path:TypePath):Maybe<TypeDefinition>
    {
        return path.modulePath.flatMap(
            function (modulePath:ModulePath)
            {
                return switch libraryResolver.getReferencedLibrary("<unknown>", modulePath.libraryName)
                {
                    case Result.Ok(library):
                        switch (library.loadType(modulePath, path.typeName))
                        {
                            case Result.Ok(type):
                                type.map(function (_type) return _type.definition);
                                
                            case Result.Err(errors):
                                throw new ConversionExeption("type not found: " + path.toString(), errors);
                        }
                        
                    case Result.Err(errors):
                        throw new ConversionExeption("library not found: " + modulePath.libraryName, errors);
                }
            }
        );
    }
}
