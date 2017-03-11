package lisla.idl.generator.output;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.idl.exception.ConversionExeption;
import lisla.idl.exception.IdlException;
import lisla.idl.generator.data.EntityOutputConfig;
import lisla.idl.generator.data.LislaToEntityOutputConfig;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.library.LibraryResolver;
import lisla.idl.library.LoadTypesContext;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.idl.std.entity.idl.TypePath;

class HaxeConvertContext implements IdlSourceProvider
{
    public var libraryResolver(default, null):LibraryResolver;
    public var entityOutputConfig(default, null):EntityOutputConfig;
    public var lislaToEntityConfig(default, null):LislaToEntityOutputConfig;
    
    public function new(
        libraryResolver:LibraryResolver, 
        entityOutputConfig:EntityOutputConfig,
        lislaToEntityConfig:LislaToEntityOutputConfig
    )
    {
        this.lislaToEntityConfig = lislaToEntityConfig;
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
