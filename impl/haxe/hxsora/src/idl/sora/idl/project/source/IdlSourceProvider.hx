package sora.idl.project.source;
import haxe.ds.Option;
import haxe.macro.Type.TypeParameter;
import sora.core.ds.Result;
import sora.core.ds.Set;
import sora.core.parse.Parser;
import sora.idl.panic.IdlSourceProviderPanic;
import sora.idl.project.error.IdlReadError;
import sora.idl.project.error.IdlReadErrorKind;
import sora.idl.std.data.idl.EnumConstructor;
import sora.idl.std.data.idl.Idl;
import sora.idl.std.data.idl.ImportDeclaration;
import sora.idl.std.data.idl.ModulePath;
import sora.idl.std.data.idl.TypeDefinition;
import sora.idl.std.data.idl.TypeName;
import sora.idl.std.data.idl.TypeNameDeclaration;
import sora.idl.std.data.idl.TypeParameterDeclaration;
import sora.idl.std.data.idl.TypePath;
import sora.idl.std.data.idl.TypeReference;
import sora.idl.std.data.idl.path.TypeGroupPath;
import sora.idl.std.data.idl.project.SourceConfig;
import sora.idl.std.desoralize.idl.IdlDesoralizer;
import sora.idl.std.tools.idl.TypeDefinitionTools;
import sys.FileSystem;
import sys.io.File;

class IdlSourceProvider
{
	private var directories:Array<String>;
	private var root:PackageElement;
	
	public function new(homeDirectory:String, config:SourceConfig) 
	{
		directories = [homeDirectory + "/std"];
		for (source in config.sources)
		{
			directories.push(source);
		}
		
		root = {
			directory: {
				completed: false,
				children: new Map(),
			},
			module: ModuleState.Unparsed,
		};
	}
	
	public function resolveGroups(targets:Array<TypeGroupPath>):Result<Map<TypePath, TypeDefinition>, Array<IdlReadError>>
	{
		var errors:Array<IdlReadError> = [];
		var result:Map<TypePath, TypeDefinition> = new Map();
		for (target in targets)
		{
			new TypeGroupResolver(this, result, errors, target);
		}
		
		return if (errors.length == 0)
		{
			Result.Ok(result);
		}
		else
		{
			Result.Err(errors);
		}
	}
}

@:access(sora.idl.project.source.IdlSourceProvider)
private class TypeGroupResolver
{
	private var groupPath:TypeGroupPath;
	private var errors:Array<IdlReadError>;
	private var output:Map<TypePath, TypeDefinition>;
	private var provider:IdlSourceProvider;
	
	public function new(provider:IdlSourceProvider, output:Map<TypePath, TypeDefinition>, errors:Array<IdlReadError>, groupPath:TypeGroupPath) 
	{
		this.provider = provider;
		this.output = output;
		this.errors = errors;
		this.groupPath = groupPath;
		
		var pathArray = groupPath.packagePath.toArray();
		var packageElement = switch (getCacheWithPath(pathArray))
		{
			case Option.Some(data):
				data;
				
			case Option.None:
				return;
		}
		
		switch (groupPath.typeName)
		{
			case Option.Some(typeName):
				var modulePath = new ModulePath(pathArray);
				_readModule(packageElement, modulePath);
				
				var typePath = new TypePath(Option.Some(modulePath), typeName);
				switch(packageElement.module)
				{
					case ModuleState.Parsed(map):
						if (map.exists(typeName))
						{
							output[typePath] = map[typeName];
						}
						
					case ModuleState.Parsing(_) | ModuleState.Unparsed:
						throw new IdlSourceProviderPanic("module state must be parsed");
				}
				
			case Option.None:
				readPackage(packageElement, pathArray);
				fetchPackage(packageElement, pathArray, output);
		}
	}
	
	private function getCacheWithPath(pathArray:Array<String>):Option<PackageElement>
	{
		var current = provider.root;
		var localPath = "";
		for (path in pathArray)
		{
			localPath += path;
			if (current.directory.children.exists(path))
			{
				current = current.directory.children[path];
			}
			else
			{
				if (current.directory.completed)
				{
					return Option.None;
				}
				else
				{
					var next = initPackage(localPath);
					current.directory.children[path] = next;
					current = next;
				}
			}
			localPath += "/";
		}
		
		return Option.Some(current);
	}
	
	private function initPackage(localPath:String):PackageElement
	{
		var dirCompleted = true;
		for (base in provider.directories)
		{
			var dirPath = base + "/" + localPath;
			if (FileSystem.exists(dirPath) && FileSystem.isDirectory(dirPath))
			{
				dirCompleted = false;
				break;
			}
		}
		
		var moduleCompleted = true;
		for (base in provider.directories)
		{
			var filePath = base + "/" + localPath + ".idl.sora";
			if (FileSystem.exists(filePath) && !FileSystem.isDirectory(filePath))
			{
				moduleCompleted = false;
				break;
			}
		}
		
		return {
			directory: {
				completed: dirCompleted,
				children: new Map(),
			},
			module: ModuleState.Unparsed,
		}
	}
	
	private function readModule(path:ModulePath):Void
	{
		var pathArray = path.toArray();
		switch (getCacheWithPath(pathArray))
		{
			case Option.Some(data):
				_readModule(data, path);
				
			case Option.None:
				// nothing to do
		}
	}
	
	private function _readModule(currentPackage:PackageElement, currentPath:ModulePath):Void
	{
		switch (currentPackage.module)
		{
			case ModuleState.Parsed(_) | ModuleState.Parsing(_): 
				return;
				
			case ModuleState.Unparsed:
		}
		
		var localPath = currentPath.toArray().join("/");
		var loadedIdl:Option<{idl:Idl, filePath:String }> = Option.None;
		
		for (base in provider.directories)
		{
			var filePath = base + "/" + localPath + ".idl.sora";
			if (!FileSystem.exists(filePath) || FileSystem.isDirectory(filePath))
			{
				continue;
			}
			
			var content = File.getContent(filePath);
			var soraArray = switch (Parser.run(content))
			{
				case Result.Err(error):
					errors.push(new IdlReadError(filePath, IdlReadErrorKind.Parse(error)));
					continue;
					
				case Result.Ok(_soraArray):
					_soraArray;
			}
			
			var idl = switch (IdlDesoralizer.run(soraArray))
			{
				case Result.Ok(_idl):
					_idl;
					
				case Result.Err(error):
					errors.push(new IdlReadError(filePath, IdlReadErrorKind.Desoralize(error)));
					continue;
			}
			
			switch (loadedIdl)
			{
				case Option.Some(data):
					errors.push(new IdlReadError(filePath, IdlReadErrorKind.ModuleDupplicated(currentPath, data.filePath)));
					continue;
					
				case Option.None:
					loadedIdl = Option.Some({ idl:idl, filePath:filePath });
			}
		}
		
		var idl;
		var filePath;
		switch (loadedIdl)
		{
			case Option.None:
				currentPackage.module = Parsed(new Map());
				return;
				
			case Option.Some(data):
				idl = data.idl;
				filePath = data.filePath;
		}
		
		var packagePath = currentPath.packagePath;
		switch (idl.packageDeclaration)
		{
			case Package(_packagePath):
				if (packagePath.toString() != _packagePath.toString())
				{
					errors.push(new IdlReadError(filePath, IdlReadErrorKind.InvalidPackage(packagePath, _packagePath)));
				}
		}
		
		var typeNames = new Set<TypeName>(new Map<TypeName, Bool>());
		for (typeDefininition in idl.typeDefinitions)
		{
			typeNames.set(TypeDefinitionTools.getName(typeDefininition));
		}
		currentPackage.module = Parsing(typeNames);
		
		var result = new Map<TypeName, TypeDefinition>();
		for (importTarget in idl.importDeclarations)
		{
			switch (importTarget)
			{
				case ImportDeclaration.Import(module):
					readModule(module);
			}
		}
		
		for (typeDefininition in idl.typeDefinitions)
		{
			var name = TypeDefinitionTools.getName(typeDefininition);
			var path = new TypePath(Option.Some(currentPath), name);
			var typeDependents = new Set(String);
			var typeParameters = new Set(TypeName);
			
			for (typeParameter in TypeDefinitionTools.getTypeParameters(typeDefininition))
			{
				switch (typeParameter)
				{
					case TypeParameterDeclaration.TypeName(typeName):
						if (typeParameters.exists(typeName))
						{
							errors.push():
						}
						else
						{
							typeParameters.set(typeName);
						}
						
					case TypeParameterDeclaration.Dependent(dependent):
						if (dependent.name)
						{
							errors.push();
						}
						else
						{
							typeDependents.set(dependent.name);
						}
				}
			}
			
			switch (typeDefininition)
			{
				case TypeDefinition.Alias(_, type):
					unshortenTypeReference(filePath, idl.importDeclarations, type);
					
				case TypeDefinition.Enum(_, constructors):
					for (constructor in constructors)
					{
						unshortenEnumConstuctors(filePath, idl.importDeclarations, constructor);
					}
					
				case TypeDefinition.Struct(_, arguments) | TypeDefinition.Tuple(_, arguments):
					for (argument in arguments)
					{
						unshortenTypeReference(filePath, idl.importDeclarations, argument.type);
					}
					
				case TypeDefinition.Union(_, elements):
					for (element in elements)
					{
						unshortenTypeReference(filePath, idl.importDeclarations, element.type);
					}
			}
			
			result[name] = typeDefininition;
		}
		
		currentPackage.module = Parsed(result);
	}
	
	private function unshortenEnumConstuctors(filePath:String, imports:Array<ImportDeclaration>, constructor:EnumConstructor):Void
	{
		switch (constructor)
		{
			case EnumConstructor.Primitive(_):
				constructor;
				
			case EnumConstructor.Paramerterized(parameter):
				for (argument in parameter.arguments)
				{
					unshortenTypeReference(filePath, imports, argument.type);
				}
		}
	}
	
	private function unshortenTypeReference(filePath:String, imports:Array<ImportDeclaration>, type:TypeReference):Void
	{
		return switch (type)
		{
			case TypeReference.Primitive(path):
				unshortenTypePath(filePath, imports, path);
				
			case TypeReference.Generic(generic):
				unshortenTypePath(filePath, imports, generic.typePath);
				for (paramType in generic.parameters) 
				{
					unshortenTypeReference(filePath, imports, paramType);
				}
		}
	}
	
	private function unshortenTypePath(filePath:String, imports:Array<ImportDeclaration>, path:TypePath):Void
	{
		switch (path.modulePath)
		{
			case Option.Some(modulePath):
				readModule(modulePath);
				if (isInModule(modulePath, path.typeName))
				{
					errors.push(new IdlReadError(filePath, IdlReadErrorKind.TypeNotFound(path)));
				}
				
			case Option.None:
				if (!path.isCoreType())
				{
					for (declaration in imports)
					{
						switch (declaration)
						{
							case ImportDeclaration.Import(module):
								if (isInModule(module, path.typeName))
								{
									path.modulePath = Option.Some(module);
									return;
								}
						}
					}
					
					errors.push(new IdlReadError(filePath, IdlReadErrorKind.TypeNotFound(path)));
				}
		}
	}
	
	private function isInModule(path:ModulePath, typeName:TypeName):Bool
	{
		return _isInModule(provider.root, path.toArray(), typeName);
	}
	
	private function _isInModule(packageElement:PackageElement, restPath:Array<String>, typeName:TypeName):Bool
	{
		return if (restPath.length == 0)
		{
			switch (packageElement.module)
			{
				case ModuleState.Parsed(map):
					map.exists(typeName);
					
				case ModuleState.Parsing(set):
					set.exists(typeName);
					
				case ModuleState.Unparsed:
					throw new IdlSourceProviderPanic("module state must be parsed");
			}
		}
		else
		{
			var head = restPath[0];
			var children = packageElement.directory.children;
			if (children.exists(head))
			{
				_isInModule(children[head], restPath.slice(1), typeName);
			}
			else
			{
				false;
			}
		}
	}
	
	private function readPackage(currentPackage:PackageElement, currentPath:Array<String>):Void
	{
		_readModule(currentPackage, new ModulePath(currentPath));
		
		if (currentPackage.directory.completed != false)
		{
			return;
		}
		
		var localPath = currentPath.join("/");
		for (base in provider.directories)
		{
			var dirPath = base + "/" + localPath;
			if (FileSystem.exists(dirPath) && FileSystem.isDirectory(dirPath))
			{
				for (childName in FileSystem.readDirectory(dirPath))
				{
					if (!currentPackage.directory.children.exists(childName))
					{
						var childPath = currentPath.concat([childName]);
						var childElement = initPackage(childPath.join("/"));
						currentPackage.directory.children[childName] = childElement;
						readPackage(childElement, childPath);
					}
				}
			}
		}
		
		currentPackage.directory.completed = true;
	}
	
	private function fetchPackage(packageElement:PackageElement, pathArray:Array<String>, output:Map<TypePath, TypeDefinition>):Void
	{
		switch(packageElement.module)
		{
			case ModuleState.Parsed(map):
				for (key in map.keys())
				{
					var typePath = new TypePath(Option.Some(new ModulePath(pathArray)), key);
					output[typePath] = map[key];
				}
				
			case ModuleState.Parsing(_) | ModuleState.Unparsed:
				throw new IdlSourceProviderPanic("module state must be parsed");
		}
	}	
}


private typedef PackageElement =
{
	directory: DirectoryElement,
	module: ModuleState,
}

private typedef DirectoryElement =
{
	completed: Bool,
	children: Map<String, PackageElement>,
}

private enum ModuleState
{
	Unparsed;
	Parsing(typeNames:Set<TypeName>);
	Parsed(typeNames:Map<TypeName, TypeDefinition>);
}

private typedef TypeNameSet =
{
	public function exists(element:TypeName):Bool;
}
