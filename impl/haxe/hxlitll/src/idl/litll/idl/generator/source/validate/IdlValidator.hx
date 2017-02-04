package litll.idl.generator.source.validate;
import litll.idl.generator.source.PackageElement;
import litll.idl.std.data.idl.TypeDefinition;

class IdlValidator 
{
    public static function run(element:PackageElement, types:Map<String, TypeDefinition>):Map<String, ValidType>
    {
        var result = new Map();
		for (name in types.keys())
		{
			result[name] = TypeDefinitionValidator.run(
                name,
                element, 
                types[name]
            );
		}
        
        return result;
    }
}
