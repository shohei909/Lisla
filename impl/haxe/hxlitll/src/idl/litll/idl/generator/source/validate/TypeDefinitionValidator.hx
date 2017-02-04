package litll.idl.generator.source.validate;
import litll.core.ds.Set;
import litll.idl.generator.error.IdlReadErrorKind;
import litll.idl.generator.source.PackageElement;
import litll.idl.generator.source.validate.InlinabilityOnTuple;
import litll.idl.generator.source.validate.TypeDefinitionValidator;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructFieldName;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.tools.idl.TypeDefinitionTools;

class TypeDefinitionValidator 
{
    private var definition:TypeDefinition;
    private var element:PackageElement;
    private var inlinablityOnTuple:InlinabilityOnTuple;
    private var typeParameters:Map<String, TypeName>;
    
    public static function run(name:String, element:PackageElement, definition:TypeDefinition):ValidType
    {
        var validator = new TypeDefinitionValidator(element, definition);
        
        validator.validate();
        
        return new ValidType(
            element.getTypePath(name),
            definition,
            validator.inlinablityOnTuple
        );
    }
    
    
    private function new(element:PackageElement, definition:TypeDefinition)
    {
        this.element = element;
        this.definition = definition;
        this.inlinablityOnTuple = InlinabilityOnTuple.Never;
    }
    
    private function validate():Void
    {
        /*
        TypeDefinitionTools.iterateOverTypeReference(definition, validateTypeRefernce);
        
        switch (definition)
		{
			case TypeDefinition.Newtype(_, type):
                validateNewType(type);
				
			case TypeDefinition.Enum(_, constructors):
				validateEnum(constructors);
				
			case TypeDefinition.Struct(_, fields):
                validateStruct(fields);
                
            case TypeDefinition.Tuple(_, arguments):
				validateTuple(arguments);
		}
        */
    }
    /*
    private function validateTypeRefernce(reference:TypeReference):Void
    {
        element.root.getElement(reference.getTypePath().getModuleArray()).iter(validateReferedElement);
    }
    private function validateReferedElement(referedElement:PackageElement):Void
    {
        referedElement.validateModule();
    }
    
	private function validateNewtype(underlyType:TypeReference):Void
	{
        
	}
    
	private function validateEnum(constructors:Array<EnumConstructor>):Void
	{
        // TODO: validation condition dupplication
        
    	var usedNames = new Set<String>(new Map());
        inline function add(name:EnumConstructorName):Void
        {
            if (usedNames.exists(name.name))
            {
                addError(IdlReadErrorKind.EnumConstuctorNameDupplicated(name));
            }
            else
            {
                usedNames.set(name.name);
            }
        }
        
        for (constructor in constructors)
		{
            switch (constructor)
            {
                case EnumConstructor.Primitive(name):
                    add(name);
                    
                case EnumConstructor.Parameterized(parameterized):
                    add(parameterized.name);
                    processTupleElements(parameterized.elements);
            }
        }
	}
    
    private function processStructFields(fields:Array<StructElement>):Void
    {
        // TODO: validation condition dupplication
        
    -	var usedNames = new Set<String>(new Map());
        inline function add(name:StructFieldName):Void
        {
            if (usedNames.exists(name.name))
            {
                addError(IdlReadErrorKind.StructFieldNameDupplicated(name));
            }
            else
            {
                usedNames.set(name.name);
            }
        }
        
        for (field in fields)
        {
            switch (field)
            {
                case StructElement.Label(name) | StructElement.NestedLabel(name):
                    add(name);
                    // TODO: validation kind
                    
                case StructElement.Field(field):
                    add(field.name);
                    processTypeReference(field.type);
                    
                    // TODO: validation default value
            }
        }
    }
    
	private function validateTuple(arguments:Array<TupleElement>):Void
	{
        // TODO: validation condition dupplication
        
		var usedNames = new Set<String>(new Map());
		for (argument in arguments)
		{
            switch (argument)
            {
                case TupleElement.Label(_):
                    // Nothing to do.
                
                case TupleElement.Argument(argument):
                    if (usedNames.exists(argument.name.name))
                    {
                        addError(IdlReadErrorKind.ArgumentNameDupplicated(argument.name));
                    }
                    else
                    {
                        usedNames.set(argument.name.name);
                        processTypeReference(argument.type);
                    }
                    
                    // TODO: validation default value
            }
		}
	}
    */
}
