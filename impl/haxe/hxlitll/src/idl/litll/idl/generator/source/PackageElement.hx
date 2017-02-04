package litll.idl.generator.source;

import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.idl.exception.SourceException;
import litll.idl.generator.error.IdlReadErrorKind;
import litll.idl.generator.source.preprocess.IdlPreprocessor;
import litll.idl.generator.source.validate.IdlValidator;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.tools.idl.TypeDefinitionTools;

using litll.idl.generator.source.ModuleStateTools;
using litll.core.ds.MapTools;
using litll.core.ds.ResultTools;

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
			module = ModuleState.Empty;
		}
	}
	
	public function getElement(pathArray:Array<String>):Maybe<PackageElement>
	{
		if (pathArray.length == 0)
		{
			return Maybe.some(this);
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
				return Maybe.none();
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
	
	public function getTypePath(typeName:String):TypePath
	{
		return new TypePath(
            Maybe.some(getModulePath()), 
            litll.idl.std.data.idl.TypeName.create(typeName).getOrThrow()
        );
	}
	
	public function loadChildren():Void
	{
		loadModule();
		directory.loadChildren();
	}
	
	public function loadModule():Void
	{
		if (module.isLoadStarted()) return;
		
		var idl = switch (readIdl().toOption())
		{
			case Option.None:
                module = Empty;
				return;
				
			case Option.Some(data):
				data;
		}
		
		var typeMap = getTypeMap(idl.data.typeDefinitions, idl.file);
		module = ModuleState.Loading(typeMap);
		IdlPreprocessor.run(this, idl);
		module = ModuleState.Loaded(typeMap);
	}
    
    public function validateModule():Void
    {
		if (module.isValidationStarted()) return;
        
        loadModule();
        
        switch (module)
		{
			case ModuleState.Loaded(typeMap):
                module = ModuleState.Validating(typeMap);
				var validTypeMap = IdlValidator.run(this, typeMap);
                module = ModuleState.Validated(validTypeMap);
				
			case ModuleState.Empty:
				// nothing to do
		
			case ModuleState.Validated(_) | ModuleState.Validating(_):
                throw new SourceException("validation has already started");
                
			case ModuleState.Unloaded | ModuleState.Loading(_):
				throw new SourceException("must be loaded");
		}
	}
    
	public function hasModule():Bool
	{
		return switch (module)
		{
            case ModuleState.Empty:
                false;
                
			case ModuleState.Loaded(_) | ModuleState.Loading(_) | ModuleState.Validating(_) | ModuleState.Validated(_):
				true;
				
			case ModuleState.Unloaded:
				loadModule();
				hasModule();
		}
	}
    
	private function getTypeMap(types:Array<TypeDefinition>, filePath:String):Map<String, TypeDefinition>
	{
		var typeMap:Map<String, TypeDefinition> = new Map<String, TypeDefinition>();
        
		for (type in types)
		{
			var name = TypeDefinitionTools.getTypeName(type);
			if (typeMap.exists(name.toString()))
			{
				var path = new TypePath(Maybe.some(getModulePath()), name);
				root.addError(filePath, IdlReadErrorKind.TypeNameDupplicated(path));
			}
			else
			{
				typeMap.set(name.toString(), type);
			}
		}
		
		return typeMap;
	}
	
	
	public function getValidType(typeName:TypeName):Maybe<ValidType>
	{
        validateModule();
        return switch (module)
		{
			case ModuleState.Validated(data):
                data.getMaybe(typeName.toString());
				
			case ModuleState.Empty:
				Maybe.none();
			
			case ModuleState.Unloaded | ModuleState.Loading(_) | ModuleState.Loaded(_) | ModuleState.Validating(_):
                throw new SourceException("must be validated");
		}
	}
    
	public function getTypeDefinition(typeName:TypeName):Maybe<TypeDefinition>
	{
		loadModule();
        
		return switch (module)
		{
			case ModuleState.Validated(data):
                data.getMaybe(typeName.toString()).map(function (type) return type.definition);
                
			case ModuleState.Loaded(data) | ModuleState.Validating(data) | ModuleState.Loading(data):
				data.getMaybe(typeName.toString());
				
			case ModuleState.Empty:
				Maybe.none();
                
			case ModuleState.Unloaded:
				throw new SourceException("must be loaded");
		}
	}
	
	
	private function readIdl():Maybe<LoadedIdl>
	{
		var loadedIdl:Maybe<LoadedIdl> = Maybe.none();
		var localPath = directory.path.join("/");
		
		return switch (root.reader.readModule(directory.path))
		{
			case Result.Err(errors):
                for (error in errors)
                {
                    root.addError(error.filePath, error.errorKind);
                }
                
				Maybe.none();
				
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
		return switch (module)
		{
			case ModuleState.Empty:
				false;
                
			case ModuleState.Validated(data):
				data.exists(typeName.toString());
                
			case ModuleState.Loaded(data) | ModuleState.Loading(data) | ModuleState.Validating(data):
				data.exists(typeName.toString());
				
			case ModuleState.Unloaded:
				loadModule();
				hasType(typeName);
		}
	}
	
	public function fetchChildren(output:Array<ValidType>):Void
	{
		fetchModule(output);
		directory.fetchChildren(output);
	}
	
	public function fetchModule(output:Array<ValidType>):Void
	{
		validateModule();
		switch (module)
		{
			case ModuleState.Validated(data):
                for (key in data.keys())
				{
					output.push(data[key]);
				}
                
			case ModuleState.Empty:
				
			case ModuleState.Unloaded | ModuleState.Loading(_) | ModuleState.Loaded(_) | ModuleState.Validating(_):
                throw new SourceException("must be validated");
		}
	}
}
