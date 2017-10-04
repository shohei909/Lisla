package arraytree.idl.generator.source.validate;
import hxext.ds.Maybe;
import arraytree.data.meta.core.StringWithMetadata;
import arraytree.idl.library.LibraryResolver;
import arraytree.idl.library.LoadTypesContext;
import arraytree.idl.std.entity.idl.ModulePath;
import arraytree.idl.std.entity.idl.TypeDefinition;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.project.ProjectRootAndFilePath;

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
