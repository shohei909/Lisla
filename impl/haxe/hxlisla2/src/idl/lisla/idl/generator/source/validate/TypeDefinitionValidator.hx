package arraytree.idl.generator.source.validate;
import haxe.ds.Option;
import hxext.ds.Maybe;
import hxext.ds.Result;
import hxext.ds.Set;
import arraytree.idl.generator.error.IdlValidationErrorKind;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.error.LoadIdlErrorKind;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseCondition;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseConditionGroup;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseConditionTools;
import arraytree.idl.generator.source.file.IdlFilePath;
import arraytree.idl.generator.source.validate.InlinabilityOnTuple;
import arraytree.idl.generator.source.validate.TypeDefinitionValidator;
import arraytree.idl.library.Library;
import arraytree.idl.library.LibraryResolver;
import arraytree.idl.library.LoadTypesContext;
import arraytree.idl.library.PackageElement;
import arraytree.idl.std.entity.idl.EnumConstructor;
import arraytree.idl.std.entity.idl.EnumConstructorName;
import arraytree.idl.std.entity.idl.LibraryName;
import arraytree.idl.std.entity.idl.ModulePath;
import arraytree.idl.std.entity.idl.StructElement;
import arraytree.idl.std.entity.idl.StructElementName;
import arraytree.idl.std.entity.idl.TupleElement;
import arraytree.idl.std.entity.idl.TypeDefinition;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.idl.std.entity.idl.TypeReference;
import arraytree.idl.std.tools.idl.EnumConstructorTools;
import arraytree.idl.std.tools.idl.StructElementTools;
import arraytree.idl.std.tools.idl.TupleTools;
import arraytree.idl.std.tools.idl.TypeDefinitionTools;
import arraytree.project.ProjectRootAndFilePath;

class TypeDefinitionValidator implements IdlSourceProvider
{
    private var packageElement:PackageElement;
    private var inlinabilityOnTuple:InlinabilityOnTuple;
    private var file:ProjectRootAndFilePath;
    private var parameters:Array<TypeName>;
    private var errors:Array<LoadIdlError>;
    private var library:LibraryResolver;
    private var definition:TypeDefinition;
    private var context:LoadTypesContext;
    
    private var hasError(get, never):Bool;
    private function get_hasError():Bool 
    {
        return errors.length > 0;
    }
    
    public static function run(
        context:LoadTypesContext, 
        file:ProjectRootAndFilePath, 
        typePath:TypePath, 
        library:LibraryResolver, 
        definition:TypeDefinition
    ):TypeDefinitionValidationResult
    {
        var validator = new TypeDefinitionValidator(context, file, library, definition);
        validator.validate();
        
        return if (validator.errors.length > 0)
        {
            Result.Error(
                validator.errors
            );
        }
        else
        {
            Result.Ok(
                new ValidType(
                    file,
                    typePath,
                    definition,
                    validator.inlinabilityOnTuple
                )
            );
        }
    }
    
    private function new(
        context:LoadTypesContext,
        file:ProjectRootAndFilePath,
        library:LibraryResolver, 
        definition:TypeDefinition
    )
    {
        this.context = context;
        this.file = file;
        this.library = library;
        this.definition = definition;
        this.inlinabilityOnTuple = InlinabilityOnTuple.Never;
        errors = [];
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
                
            case TypeDefinition.Tuple(_, elements):
				validateTuple(elements);
		}
    }
    
    private function validateTypeRefernce(reference:TypeReference):Void
    {
        var typePath = reference.getTypePath();
        typePath.modulePath.iter(
            function (modulePath:ModulePath)
            {
                getElement(modulePath).iter(
                    function (referedElement:PackageElement):Void
                    {
                        referedElement.validateModule(context);
                    }
                );
            }
        );
    }
    
	private function validateNewtype(underlyType:TypeReference):Void
	{
        var typePath = underlyType.getTypePath();
        switch (underlyType.getConditions(this, parameters))
        {
            case Result.Ok(conditions):
                inlinabilityOnTuple = ArrayTreeToEntityCaseConditionTools.getInlinability(conditions);
                
            case Result.Error(error):
                addErrorKind(IdlValidationErrorKind.GetCondition(error));
        }
	}
    
	private function validateEnum(constructors:Array<EnumConstructor>):Void
	{
        var conditionArray = [];
        var conditionMap = new Map<String, ArrayTreeToEntityCaseConditionGroup<EnumConstructorName>>();
        var canInlineFixed = true;
        var canInline = true;
        
        inline function add(name:EnumConstructorName, conditions:Array<ArrayTreeToEntityCaseCondition>):Void
        {
            if (conditionMap.exists(name.name))
            {
                addErrorKind(IdlValidationErrorKind.EnumConstuctorNameDuplicated(conditionMap[name.name].name, name));
            }
            else
            {
                for (condition in conditions)
                {
                    conditionArray.push(condition);
                }
                conditionMap.set(name.name, new ArrayTreeToEntityCaseConditionGroup(name, conditions));
            }
        }
        
        for (constructor in constructors)
		{
            var name = EnumConstructorTools.getConstructorName(constructor);
            switch (EnumConstructorTools.getConditions(constructor, this, parameters))
            {
                case Result.Ok(conditions):
                    add(name, conditions);
                    
                case Result.Error(error):
                    addErrorKind(IdlValidationErrorKind.GetCondition(error));
            }
            
            switch (EnumConstructorTools.getOwnedTupleElements(constructor))
            {
                case Option.Some(elements):
                    validateTupleElements(elements);
                    
                case Option.None:
            }
        }
        
        if (hasError) return;
        
        inlinabilityOnTuple = ArrayTreeToEntityCaseConditionTools.getInlinability(conditionArray);
        
        switch (ArrayTreeToEntityCaseConditionGroup.intersects(conditionMap))
        {
            case Option.Some(groups):
                addErrorKind(IdlValidationErrorKind.EnumConstuctorConditionDuplicated(groups.group0.name, groups.group1.name));
                
            case Option.None:
                // success
        }
    }
    
    private function validateStruct(elements:Array<StructElement>):Void
    {
        var conditionArray = [];
        var conditionMap = new Map<String, ArrayTreeToEntityCaseConditionGroup<StructElementName>>();
        inline function add(name:StructElementName, conditions:Array<ArrayTreeToEntityCaseCondition>):Void
        {
            if (conditionMap.exists(name.name))
            {
                addErrorKind(StructElementValidationErrorKind.NameDuplicated(conditionMap[name.name].name, name));
            }
            else
            {
                for (condition in conditions)
                {
                    conditionArray.push(condition);
                }
                conditionMap.set(name.name, new ArrayTreeToEntityCaseConditionGroup(name, conditions));
            }
        }
        
        for (element in elements)
        {
            var name = StructElementTools.getName(element);
            switch (StructElementTools.getConditions(element, this, parameters))
            {
                case Result.Ok(conditions):
                    add(name, conditions);
                    
                case Result.Error(error):
                    addErrorKind(IdlValidationErrorKind.GetCondition(error));
            }
        }
        
        if (hasError) return;
        
        inlinabilityOnTuple = ArrayTreeToEntityCaseConditionTools.getInlinability(conditionArray);
        
        switch (ArrayTreeToEntityCaseConditionGroup.intersects(conditionMap))
        {
            case Option.Some(groups):
                addErrorKind(IdlValidationErrorKind.StructElementConditionDuplicated(groups.group0.name, groups.group1.name));
                
            case Option.None:
                // success
        }
    }
    
	private function validateTuple(elements:Array<TupleElement>):Void
	{
		validateTupleElements(elements);
        
        if (hasError) return;
        
        switch (TupleTools.getCondition(elements, this, parameters))
        {
            case Result.Ok(_):
                inlinabilityOnTuple = Always;
                
            case Result.Error(error):
                addErrorKind(IdlValidationErrorKind.GetCondition(error));
        }
	}
    
    private function validateTupleElements(elements:Array<TupleElement>):Void
	{
		var usedNames = new Set<String>();
		for (element in elements)
		{
            switch (element)
            {
                case TupleElement.Label(_):
                    // Nothing to do.
                
                case TupleElement.Argument(argument):
                    // TODO: validate for rest condition
                    if (usedNames.exists(argument.name.name))
                    {
                        addErrorKind(IdlValidationErrorKind.ArgumentNameDuplicated(argument.name));
                    }
                    else
                    {
                        usedNames.add(argument.name.name);
                    }
            }
		}
    }
    
	private function addErrorKind(kind:IdlValidationErrorKind):Void 
	{
		errors.push(new LoadIdlError(file, LoadIdlErrorKind.Validation(kind)));
	}
    
    
    private function getElement(path:ModulePath):Maybe<PackageElement>
    {
        return getReferencedLibrary(path.libraryName).flatMap(
            function (lib)
            {
                return lib.getModuleElement(path);
            }
        );
    }
    
    public function resolveTypePath(path:TypePath):Maybe<TypeDefinition>
    {
        return path.modulePath.flatMap(
            function (modulePath)
            {
                return getElement(modulePath).flatMap(
                    function (element) return element.getTypeDefinition(context, path.typeName)
                );
            }
        );
    }
    
    private function getReferencedLibrary(name:LibraryName):Maybe<Library>
    {
        return switch library.getReferencedLibrary(file, name)
        {
            case Result.Ok(ok):
                Maybe.some(ok);
                
            case Result.Error(errors):
                for (e in errors) errors.push(e);
                Maybe.none();
        }
    }
}
