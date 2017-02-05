package litll.idl.generator.source.validate;
import litll.core.ds.Result;
import litll.core.ds.Set;
import litll.idl.generator.error.IdlReadErrorKind;
import litll.idl.generator.source.PackageElement;
import litll.idl.generator.source.file.IdlFilePath;
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
import litll.idl.std.tools.idl.error.TypeFollowErrorKindTools;

class TypeDefinitionValidator 
{
    private var definition:TypeDefinition;
    private var element:PackageElement;
    private var inlinablityOnTuple:InlinabilityOnTuple;
    private var file:IdlFilePath;
    private var parameters:Array<TypeName>;
    
    public static function run(file:IdlFilePath, name:String, element:PackageElement, definition:TypeDefinition):ValidType
    {
        var validator = new TypeDefinitionValidator(file, element, definition);
        
        validator.validate();
        
        return new ValidType(
            file,
            element.getTypePath(name),
            definition,
            validator.inlinablityOnTuple
        );
    }
    
    private function new(file:IdlFilePath, element:PackageElement, definition:TypeDefinition)
    {
        this.file = file;
        this.element = element;
        this.definition = definition;
        this.inlinablityOnTuple = InlinabilityOnTuple.Never;
    }
    
    private function validate():Void
    {
        TypeDefinitionTools.iterateOverTypeReference(definition, validateTypeRefernce);
        parameters = TypeDefinitionTools.getTypeParameters(definition).collect().parameters;
        
        switch (definition)
		{
			case TypeDefinition.Newtype(_, type):
                validateNewtype(type);
				
			case TypeDefinition.Enum(_, constructors):
				validateEnum(constructors);
				
			case TypeDefinition.Struct(_, fields):
                validateStruct(fields);
                
            case TypeDefinition.Tuple(_, arguments):
				validateTuple(arguments);
		}
    }
    
    private function validateTypeRefernce(reference:TypeReference):Void
    {
        var typePath = reference.getTypePath();
        element.root.getElement(typePath.getModuleArray()).iter(
            function (referedElement:PackageElement):Void
            {
                referedElement.validateModule();
            }
        );
    }
    
	private function validateNewtype(underlyType:TypeReference):Void
	{
        var typePath = underlyType.getTypePath();
        switch (underlyType.follow(element.root, parameters))
        {
            case Result.Ok(data):
                // nothing to do.
                
            case Result.Err(error):
                addError(TypeFollowErrorKindTools.toIdlReadErrorKind(error));
        }
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
                    validateTuple(parameterized.elements);
            }
        }
	}
    
    private function validateStruct(fields:Array<StructElement>):Void
    {
        // TODO: validation condition dupplication
    	var usedNames = new Set<String>(new Map());
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
                    }
                    
                    // TODO: validation default value
            }
		}
	}
    
	private function addError(kind:IdlReadErrorKind):Void 
	{
		element.root.addError(file, kind);
	}
}
