package lisla.idl.generator.source.validate;
import hxext.ds.Maybe;
import lisla.data.meta.core.StringWithMetadata;
import lisla.idl.library.LibraryResolver;
import lisla.idl.library.LoadTypesContext;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;
import lisla.project.ProjectRootAndFilePath;

class IdlValidator 
{
    public static function run(
        context:LoadTypesContext, 
        filePath:ProjectRootAndFilePath, 
        modulePath:ModulePath, 
        library:LibraryResolver, 
        types:Map<String, TypeDefinition>
    ):Map<String, TypeDefinitionValidationResult>
    {
        var result = new Map();
		for (name in types.keys())
		{
			result[name] = TypeDefinitionValidator.run(
                context,
                filePath,
                new TypePath(
                    Maybe.some(modulePath), 
                    new TypeName(new StringWithMetadata(name, modulePath.metadata)),
                    modulePath.metadata
                ),
                library, 
                types[name]
            );
		}
        
        return result;
    }
}
