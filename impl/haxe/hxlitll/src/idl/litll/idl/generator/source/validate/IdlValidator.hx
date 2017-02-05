package litll.idl.generator.source.validate;
import litll.idl.generator.source.PackageElement;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.std.data.idl.TypeDefinition;

class IdlValidator 
{
    public static function run(file:IdlFilePath, element:PackageElement, types:Map<String, TypeDefinition>):Map<String, ValidType>
    {
        var result = new Map();
		for (name in types.keys())
		{
			result[name] = TypeDefinitionValidator.run(
                file,
                name,
                element, 
                types[name]
            );
		}
        
        return result;
    }
}
