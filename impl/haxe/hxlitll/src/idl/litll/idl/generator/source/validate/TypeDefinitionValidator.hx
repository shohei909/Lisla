package litll.idl.generator.source.validate;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.core.ds.Set;
import litll.idl.generator.error.IdlReadErrorKind;
import litll.idl.generator.error.IdlValidationErrorKind;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyCaseConditionGroup;
import litll.idl.generator.output.delitll.match.DelitllfyCaseConditionTools;
import litll.idl.generator.source.PackageElement;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.validate.InlinabilityOnTuple;
import litll.idl.generator.source.validate.TypeDefinitionValidator;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructElementName;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.error.GetConditionErrorKindTools;
import litll.idl.std.error.TypeFollowErrorKindTools;
import litll.idl.std.tools.idl.EnumConstructorTools;
import litll.idl.std.tools.idl.FollowedTypeDefinitionTools;
import litll.idl.std.tools.idl.StructElementTools;
import litll.idl.std.tools.idl.TypeDefinitionTools;
import litll.idl.std.tools.idl.TypeReferenceTools;

class TypeDefinitionValidator 
{
    private var definition:TypeDefinition;
    private var packageElement:PackageElement;
    private var inlinabilityOnTuple:InlinabilityOnTuple;
    private var file:IdlFilePath;
    private var parameters:Array<TypeName>;
    private var hasError:Bool;
    
    public static function run(file:IdlFilePath, name:String, element:PackageElement, definition:TypeDefinition):ValidType
    {
        var validator = new TypeDefinitionValidator(file, element, definition);
        
        validator.validate();
        
        return new ValidType(
            file,
            element.getTypePath(name),
            definition,
            validator.inlinabilityOnTuple
        );
    }
    
    private function new(file:IdlFilePath, element:PackageElement, definition:TypeDefinition)
    {
        this.file = file;
        this.packageElement = element;
        this.definition = definition;
        this.inlinabilityOnTuple = InlinabilityOnTuple.Never;
        hasError = false;
    }
    
    private function validate():Void
    {
        TypeDefinitionTools.iterateOverTypeReference(definition, validateTypeRefernce);
        parameters = TypeDefinitionTools.getTypeParameters(definition).collect().parameters;
        
        if (hasError) return;
        
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
        packageElement.root.getElement(typePath.getModuleArray()).iter(
            function (referedElement:PackageElement):Void
            {
                referedElement.validateModule();
            }
        );
    }
    
	private function validateNewtype(underlyType:TypeReference):Void
	{
        var typePath = underlyType.getTypePath();
        switch (underlyType.getConditions(packageElement.root, parameters))
        {
            case Result.Ok(conditions):
                inlinabilityOnTuple = DelitllfyCaseConditionTools.getInlinability(conditions);
                
            case Result.Err(error):
                addError(IdlValidationErrorKind.GetCondition(error));
        }
	}
    
	private function validateEnum(constructors:Array<EnumConstructor>):Void
	{
        var conditionMap = new Map<String, DelitllfyCaseConditionGroup<EnumConstructorName>>();
        var canInlineFixed = true;
        var canInline = true;
        
        inline function add(name:EnumConstructorName, conditions:Array<DelitllfyCaseCondition>):Void
        {
            if (conditionMap.exists(name.name))
            {
                addError(IdlValidationErrorKind.EnumConstuctorNameDuplicated(conditionMap[name.name].name, name));
            }
            else
            {
                conditionMap.set(name.name, new DelitllfyCaseConditionGroup(name, conditions));
            }
        }
        
        for (constructor in constructors)
		{
            var name = EnumConstructorTools.getConstructorName(constructor);
            switch (EnumConstructorTools.getConditions(constructor, packageElement.root, parameters))
            {
                case Result.Ok(conditions):
                    add(name, conditions);
                    
                case Result.Err(error):
                    addError(IdlValidationErrorKind.GetCondition(error));
            }
        }
        
        if (hasError) return;
        
        switch (DelitllfyCaseConditionGroup.intersects(conditionMap))
        {
            case Option.Some(groups):
                addError(IdlValidationErrorKind.EnumConstuctorConditionDuplicated(groups.group0.name, groups.group1.name));
                
            case Option.None:
                // success
        }
        
        if (hasError) return;
        
	}
    
    private function validateStruct(elements:Array<StructElement>):Void
    {
        var conditionMap = new Map<String, DelitllfyCaseConditionGroup<StructElementName>>();
        inline function add(name:StructElementName, conditions:Array<DelitllfyCaseCondition>):Void
        {
            if (conditionMap.exists(name.name))
            {
                addError(IdlValidationErrorKind.StructElementNameDuplicated(conditionMap[name.name].name, name));
            }
            else
            {
                conditionMap.set(name.name, new DelitllfyCaseConditionGroup(name, conditions));
            }
        }
        
        for (element in elements)
        {
            var name = StructElementTools.getName(element);
            switch (StructElementTools.getConditions(element, packageElement.root, parameters))
            {
                case Result.Ok(conditions):
                    add(name, conditions);
                    
                case Result.Err(error):
                    addError(IdlValidationErrorKind.GetCondition(error));
            }
        }
        
        switch (DelitllfyCaseConditionGroup.intersects(conditionMap))
        {
            case Option.Some(groups):
                addError(IdlValidationErrorKind.StructElementConditionDuplicated(groups.group0.name, groups.group1.name));
                
            case Option.None:
                // success
        }
        
        
    }
    
	private function validateTuple(arguments:Array<TupleElement>):Void
	{
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
                        addError(IdlValidationErrorKind.ArgumentNameDuplicated(argument.name));
                    }
                    else
                    {
                        usedNames.set(argument.name.name);
                    }
                    
                    // TODO: validation default value
            }
		}
        
        
	}
    
	private function addError(kind:IdlValidationErrorKind):Void 
	{
        hasError = true;
		packageElement.root.addError(file, IdlReadErrorKind.Validation(kind));
	}
}


