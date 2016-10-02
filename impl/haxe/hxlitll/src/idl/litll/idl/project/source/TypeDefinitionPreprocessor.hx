package litll.idl.project.source;

import haxe.ds.Option;
import litll.core.ds.Result;
import litll.core.ds.Set;
import litll.idl.delitllfy.Delitllfier;
import litll.idl.delitllfy.DelitllfyContext;
import litll.idl.project.error.IdlReadErrorKind;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.TypeReferenceParameter;
import litll.idl.std.data.idl.TypeReferenceParameterKind;
import litll.idl.std.delitllfy.idl.TypeReferenceDelitllfier;
using litll.idl.std.tools.idl.TypeDefinitionTools;

class TypeDefinitionPreprocessor
{
	private var parent:IdlPreprocessor;
	private var target:TypeDefinition;
	private var typeParameters:Set<TypeName>;
	
	public static function run(parent:IdlPreprocessor, target:TypeDefinition):Void
	{
		var runner = new TypeDefinitionPreprocessor(parent, target);
		runner.processTypeParameters();
		runner.processBody();
	}
	
	private function new(parent:IdlPreprocessor, target:TypeDefinition)
	{
		this.parent = parent;
		this.target = target;
	}
	
	private function processTypeParameters():Void
	{
		var typeDependences = new Set<TypeDependenceName>(new Map());
		this.typeParameters = new Set<TypeName>(new Map());
		
		for (typeParameter in target.getTypeParameters())
		{
			switch (typeParameter)
			{
				case TypeParameterDeclaration.TypeName(typeName):
					if (typeParameters.exists(typeName))
					{
						addError(IdlReadErrorKind.TypeParameterNameDupplicated(typeName));
					}
					else
					{
						typeParameters.set(typeName);
					}
					
				case TypeParameterDeclaration.Dependence(dependence):
					if (typeDependences.exists(dependence.name))
					{
						addError(IdlReadErrorKind.TypeDependenceNameDupplicated(dependence.name));
					}
					else
					{
						typeDependences.set(dependence.name);
					}
			}
		}
	}
	
	private function processBody():Void
	{
		switch (target)
		{
			case TypeDefinition.Alias(_, type):
				processTypeReference(type);
				
			case TypeDefinition.Enum(_, constructors):
				for (constructor in constructors)
				{
					processEnumConstuctors(constructor);
				}
				
			case TypeDefinition.Struct(_, arguments) | TypeDefinition.Tuple(_, arguments):
				processArguments(arguments);
				
			case TypeDefinition.Union(_, elements):
				for (element in elements)
				{
					processTypeReference(element.type);
				}
		}
	}
	
	private function processEnumConstuctors(constructor:EnumConstructor):Void
	{
		switch (constructor)
		{
			case EnumConstructor.Primitive(_):
				constructor;
				
			case EnumConstructor.Parameterized(parameter):
				processArguments(parameter.arguments);
		}
	}
	
	private function processArguments(arguments:Array<Argument>) 
	{
		var usedNames = new Set<String>(new Map());
		for (argument in arguments)
		{
			if (usedNames.exists(argument.name.name))
			{
				addError(IdlReadErrorKind.ArgumentNameDupplicated(argument.name.name));
			}
			else
			{
				usedNames.set(argument.name.name);
				processTypeReference(argument.type);
			}
		}
	}
	
	private function processTypeReference(type:TypeReference):Void
	{
		var path, parameters;
		switch (type)
		{
			case TypeReference.Primitive(p):
				path = p;
				parameters = [];
				
			case TypeReference.Generic(generic):
				path = generic.typePath;
				parameters = generic.parameters;
		}
		
		switch (path.modulePath)
		{
			case Option.Some(modulePath):
				switch (parent.element.root.getElement(modulePath.toArray()))
				{
					case Option.Some(referredElement):
						switch (referredElement.getType(path.typeName))
						{
							case Option.Some(type):
								processTypeReferenceParameters(path, type.getTypeParameters(), parameters);
								
							case Option.None:
								addError(IdlReadErrorKind.TypeNotFound(path));
						}
						
					case Option.None:
						addError(IdlReadErrorKind.ModuleNotFound(modulePath));
				}
				
			case Option.None:
				if (path.typeName.toString() == "Array")
				{
					processTypeReferenceParameters(
						path, 
						[TypeParameterDeclaration.TypeName(new TypeName("T"))], 
						parameters
					);
					return;
				}
				if (path.isCoreType() || typeParameters.exists(path.typeName)) 
				{
					if (parameters.length != 0)
					{
						addError(IdlReadErrorKind.InvalidTypeParameterLength(path, 0, parameters.length));
					}
					return;
				}
				
				for (importedElement in parent.importedElements)
				{
					switch (importedElement.getType(path.typeName))
					{
						case Option.Some(type):
							var module = importedElement.getModulePath();
							path.modulePath = Option.Some(module);
							processTypeReferenceParameters(path, type.getTypeParameters(), parameters);
							break;
							
						case Option.None:
					}
				}
				
				if (path.modulePath.match(Option.None))
				{
					addError(IdlReadErrorKind.TypeNotFound(path));
				}
		}
	}
	
	private function processTypeReferenceParameters(path:TypePath, definitionParameters:Array<TypeParameterDeclaration>, referenceParameters:Array<TypeReferenceParameter>):Void 
	{
		if (referenceParameters.length != definitionParameters.length)
		{
			addError(
				IdlReadErrorKind.InvalidTypeParameterLength(
					path, definitionParameters.length, referenceParameters.length
				)
			);
		}
		
		var iter = referenceParameters.iterator();
		for (definitionParameter in definitionParameters)
		{
			var referenceParameter = iter.next();
			var processedValue = switch (definitionParameter)
			{
				case TypeParameterDeclaration.Dependence(dependence):
					TypeReferenceParameterKind.Dependence(dependence.type);
					
				case TypeParameterDeclaration.TypeName(_):
					var context = new DelitllfyContext(Option.None, referenceParameter.value, parent.element.root.reader.config);
					switch (TypeReferenceDelitllfier.process(context))
					{
						case Result.Ok(reference):
							processTypeReference(reference);
							TypeReferenceParameterKind.Type(reference);
							
						case Result.Err(err):
							addError(IdlReadErrorKind.Delitll(err));
							return;
					}
			}
			
			referenceParameter.processedValue = Option.Some(processedValue);
		}
	}
	
	private function addError(kind:IdlReadErrorKind):Void 
	{
		parent.addError(kind);
	}
}