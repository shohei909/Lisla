package arraytree.idl.generator.output;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.idl.exception.ConversionExeption;
import arraytree.idl.exception.IdlException;
import arraytree.idl.generator.data.EntityOutputConfig;
import arraytree.idl.generator.data.ArrayTreeToEntityOutputConfig;
import arraytree.idl.generator.source.IdlSourceProvider;
import arraytree.idl.library.LibraryResolver;
import arraytree.idl.library.LoadTypesContext;
import arraytree.idl.std.entity.idl.ModulePath;
import arraytree.idl.std.entity.idl.TypeDefinition;
import arraytree.idl.std.entity.idl.TypePath;

class HaxeConvertContext implements IdlSourceProvider
{
    public var libraryResolver(default, null):LibraryResolver;
    public var entityOutputConfig(default, null):EntityOutputConfig;
    public var arraytreeToEntityConfig(default, null):ArrayTreeToEntityOutputConfig;
    
    public function new(
        libraryResolver:LibraryResolver, 
        entityOutputConfig:EntityOutputConfig,
        arraytreeToEntityConfig:ArrayTreeToEntityOutputConfig
    )
    {
        this.arraytreeToEntityConfig = arraytreeToEntityConfig;
        this.libraryResolver = libraryResolver;
        this.entityOutputConfig = entityOutputConfig;
    }
    
    public function resolveTypePath(path:TypePath):Maybe<TypeDefinition>
    {
        return path.modulePath.flatMap(
            function (modulePath:ModulePath)
            {
                return switch libraryResolver.getLibrary(modulePath.libraryName)
                {
                    case Result.Ok(library):
                        switch (library.loadType(modulePath, path.typeName))
                        {
                            case Result.Ok(type):
                                type.map(function (_type) return _type.definition);
                                
                            case Result.Error(errors):
                                throw new ConversionExeption("type not found: " + path.toString(), errors);
                        }
                        
                    case Result.Error(error):
                        throw new ConversionExeption("library not found: " + modulePath.libraryName, errors);
                }
            }
        );
    }
}
