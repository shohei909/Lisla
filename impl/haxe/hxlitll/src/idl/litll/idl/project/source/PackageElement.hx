package litll.idl.project.source;

import haxe.ds.Option;
import litll.core.ds.Result;
import litll.core.ds.Set;
import litll.idl.project.error.IdlReadErrorKind;
import litll.idl.exception.SourceException;
import litll.idl.std.data.idl.Idl;
import litll.idl.std.data.idl.ImportDeclaration;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeDependenceName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeParameterDeclaration;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.tools.idl.TypeDefinitionTools;
import sys.FileSystem;
import litll.idl.std.data.idl.Idl;
import unifill.Exception;

using litll.idl.project.source.ModuleStateTools;
using litll.core.ds.MapTools;

class PackageElement
{
	public var directory(default, null):DirectoryElement;
	public var module(default, null):ModuleState;
	public var root(default, null):RootPackageElement;
	
	public function new(root:RootPackageElement, path:Array<String>) 
	{
		this.root = root;
		directory = new DirectoryElement(root, path);
		
		module = ModuleState.Unloaded;
		initModule();
	}
	
	private function initModule():Void
	{
		if (!root.reader.moduleExists(directory.path))
		{
			module = ModuleState.Loaded(Option.None);
		}
	}
	
	
	public function getElement(pathArray:Array<String>):Option<PackageElement>
	{
		if (pathArray.length == 0)
		{
			return Option.Some(this);
		}
		
		var head = pathArray[0];
		return if (directory.children.exists(head))
		{
			directory.children[head].getElement(pathArray.slice(1));
		}
		else
		{
			if (directory.loaded)
			{
				return Option.None;
			}
			else
			{
				directory.addChild(head).getElement(pathArray.slice(1));
			}
		}
	}
	
	public function getModulePath():ModulePath
	{
		return new ModulePath(directory.path);
	}
	
	public function getTypePath(typeName:TypeName):TypePath
	{
		return new TypePath(Option.Some(getModulePath()), typeName);
	}
	
	public function loadChildren():Void
	{
		loadModule();
		directory.loadChildren();
	}
	
	public function loadModule():Void
	{
		if (module.isParseStarted()) return;
		
		var idl = switch (readIdl())
		{
			case Option.None:
				module = Loaded(Option.None);
				return;
				
			case Option.Some(data):
				data;
		}
		
		var typeMap = getTypeMap(idl.data.typeDefinitions, idl.file);
		module = Loading(typeMap);
		IdlPreprocessor.run(this, idl);
		module = Loaded(Option.Some(typeMap));
	}
	
	public function hasModule():Bool
	{
		return switch (module)
		{
			case ModuleState.Loaded(data):
				data.match(Option.Some(_));
				
			case ModuleState.Loading(set):
				true;
				
			case ModuleState.Unloaded:
				loadModule();
				switch (module)
				{
					case ModuleState.Loaded(data):
						data.match(Option.Some(_));
						
					case ModuleState.Unloaded | ModuleState.Loading(_): 
						throw new SourceException("must be loaded");
				}
		}
	}
	
	private function getTypeMap(types:Array<TypeDefinition>, filePath:String):Map<TypeName, TypeDefinition>
	{
		var typeMap = new Map<TypeName, TypeDefinition>();
		for (type in types)
		{
			var name = TypeDefinitionTools.getName(type);
			if (typeMap.exists(name))
			{
				var path = new TypePath(Option.Some(getModulePath()), name);
				root.addError(filePath, IdlReadErrorKind.TypeNameDupplicated(path));
			}
			else
			{
				typeMap.set(name, type);
			}
		}
		
		return typeMap;
	}
	
	
	public function getType(typeName:TypeName):Option<TypeDefinition>
	{
		loadModule();
		
		return switch (module)
		{
			case ModuleState.Loaded(Option.Some(data)) | ModuleState.Loading(data):
				data.getOption(typeName);
				
			case ModuleState.Loaded(Option.None):
				Option.None;
			
			case ModuleState.Unloaded:
				throw new SourceException("must be loaded");
		}
	}
	
	
	private function readIdl():Option<LoadedIdl>
	{
		var loadedIdl:Option<LoadedIdl> = Option.None;
		var localPath = directory.path.join("/");
		
		return switch (root.reader.readModule(directory.path))
		{
			case Result.Err(error):
				root.addError(error.filePath, error.errorKind);
				Option.None;
				
			case Result.Ok(idl):
				idl;
		}
	}
	
	private function containsType(restPath:Array<String>, typeName:TypeName):Bool
	{
		return if (restPath.length == 0)
		{
			hasType(typeName);
		}
		else
		{
			var head = restPath[0];
			var children = directory.children;
			if (children.exists(head))
			{
				children[head].containsType(restPath.slice(1), typeName);
			}
			else
			{
				false;
			}
		}
	}
	
	public function hasType(typeName:TypeName):Bool
	{
		inline function exists(data:Option<Map<TypeName, TypeDefinition>>):Bool
		{
			return switch (data)
			{
				case Option.Some(map):
					map.exists(typeName);
					
				case Option.None:
					false;
			}
		}
		
		return switch (module)
		{
			case ModuleState.Loaded(data):
				exists(data);
				
			case ModuleState.Loading(set):
				set.exists(typeName);
				
			case ModuleState.Unloaded:
				loadModule();
				switch (module)
				{
					case ModuleState.Loaded(data):
						exists(data);
						
					case ModuleState.Unloaded | ModuleState.Loading(_): 
						throw new SourceException("must be loaded");
				}
		}
	}
	
	public function fetchChildren(output:Map<TypePath, TypeDefinition>):Void
	{
		fetchModule(output);
		directory.fetchChildren(output);
	}
	
	public function fetchModule(output:Map<TypePath, TypeDefinition>):Void
	{
		loadModule();
		switch (module)
		{
			case ModuleState.Loaded(Option.None):
				
			case ModuleState.Loaded(Option.Some(data)) | ModuleState.Loading(data):
				for (key in data.keys())
				{
					output[getTypePath(key)] = data[key];
				}
				
			case ModuleState.Unloaded: 
				throw new SourceException("must be loaded");
		}
	}
}
