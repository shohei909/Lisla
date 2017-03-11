package litll.idl.generator.source.validate;
import hxext.ds.Maybe;
import litll.core.LitllString;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.library.LibraryResolver;
import litll.idl.library.LoadTypesContext;
import litll.idl.std.entity.idl.ModulePath;
import litll.idl.std.entity.idl.TypeDefinition;
import litll.idl.std.entity.idl.TypeName;
import litll.idl.std.entity.idl.TypePath;

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
                    new TypeName(new LitllString(name, modulePath.tag)),
                    modulePath.tag
                ),
                library, 
                types[name]
            );
		}
        
        return result;
    }
}
