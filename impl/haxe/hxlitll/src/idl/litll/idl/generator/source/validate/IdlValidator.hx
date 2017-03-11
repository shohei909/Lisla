package litll.idl.generator.source.validate;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.library.LoadTypesContext;
import litll.idl.library.PackageElement;
import litll.idl.std.data.idl.TypeDefinition;

class IdlValidator 
{
    public static function run(context:LoadTypesContext, file:IdlFilePath, element:PackageElement, types:Map<String, TypeDefinition>):Map<String, TypeDefinitionValidationResult>
    {
        var result = new Map();
		for (name in types.keys())
		{
			result[name] = TypeDefinitionValidator.run(
                context,
                file,
                name,
                element, 
                types[name]
            );
		}
        
        return result;
    }
}
