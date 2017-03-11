package lisla.idl.generator.source.validate;
import hxext.ds.Maybe;
import lisla.core.LislaString;
import lisla.idl.generator.source.file.IdlFilePath;
import lisla.idl.library.LibraryResolver;
import lisla.idl.library.LoadTypesContext;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;

class IdlValidator 
{
    public static function run(context:LoadTypesContext, file:IdlFilePath, modulePath:ModulePath, library:LibraryResolver, types:Map<String, TypeDefinition>):Map<String, TypeDefinitionValidationResult>
    {
        var result = new Map();
		for (name in types.keys())
		{
			result[name] = TypeDefinitionValidator.run(
                context,
                file,
                new TypePath(
                    Maybe.some(modulePath), 
                    new TypeName(new LislaString(name, modulePath.tag)),
                    modulePath.tag
                ),
                library, 
                types[name]
            );
		}
        
        return result;
    }
}
