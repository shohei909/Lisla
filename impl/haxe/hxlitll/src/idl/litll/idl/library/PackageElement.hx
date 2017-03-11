package litll.idl.library;

import haxe.ds.Option;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.idl.exception.SourceException;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.error.ReadIdlErrorKind;
import litll.idl.generator.source.DirectoryElement;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.file.LoadedIdl;
import litll.idl.generator.source.preprocess.IdlPreprocessor;
import litll.idl.generator.source.validate.IdlValidator;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.library.ModuleState;
import litll.idl.std.data.idl.PackagePath;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.tools.idl.TypeDefinitionTools;

using litll.idl.library.ModuleStateTools;
using hxext.ds.MapTools;
using hxext.ds.ResultTools;

class PackageElement
{
    // ========================
    // Parent
    // ========================
    public var library(default, null):Library;
    
    // ========================
    // Children
    // ========================
	public var directory(default, null):DirectoryElement;
	public var module(default, null):ModuleState;
    public var path(default, null):PackagePath;
    
	public function new(library:Library, path:PackagePath) 
	{
		this.path = path;
        this.library = library;
        
		directory = new DirectoryElement(this);
		module = ModuleState.Unloaded;
		initModule();
	}
	
	private function initModule():Void
	{
		if (!library.moduleExistsAt(path.toModulePath()))
		{
			module = ModuleState.Empty;
		}
	}
	
	public function getLocalElement(pathArray:Array<String>):Maybe<PackageElement>
	{
		if (pathArray.length == 0)
		{
			return Maybe.some(this);
		}
		
		var head = pathArray[0];
		return if (directory.children.exists(head))
		{
			directory.children[head].getLocalElement(pathArray.slice(1));
		}
		else
		{
			if (directory.loaded)
			{
				return Maybe.none();
			}
			else
			{
				directory.addChild(head).getLocalElement(pathArray.slice(1));
			}
		}
	}
	
	public function getTypePath(typeName:String):TypePath
	{
		return new TypePath(
            Maybe.some(path.toModulePath()), 
            litll.idl.std.data.idl.TypeName.create(typeName).getOrThrow()
        );
	}
	
	public function loadChildren(context:LoadTypesContext):Void
	{
		loadModule(context);
		directory.loadChildren(context);
	}
	
	public function loadModule(context:LoadTypesContext):Void
	{
		if (module.isLoadStarted()) return;
		
		var idl = switch (readIdl(context).toOption())
		{
			case Option.None:
                module = Empty;
				return;
				
			case Option.Some(data):
				data;
		}
		
		var typeMap = switch (getTypeMap(idl.data.typeDefinitions, idl.file))
        {
            case Result.Ok(data):
                data;
                
            case Result.Err(error):
                module = ModuleState.Loaded(Result.Err([new ReadIdlError(idl.file, error)]), idl.file);
                return;
        }
        
		module = ModuleState.Loading(typeMap, idl.file);
		var result = IdlPreprocessor.run(context, this, path.toModulePath(), idl, typeMap);
		module = ModuleState.Loaded(result, idl.file);
	}
    
    public function validateModule(context:LoadTypesContext):Void
    {
		if (module.isValidationStarted()) return;
        
        loadModule(context);
        
        switch (module)
		{
			case ModuleState.Loaded(loadResult, file):
                switch (loadResult)
                {
                    case Result.Ok(typeMap):
                        module = ModuleState.Validating(typeMap, file);
                        var validTypeMap = IdlValidator.run(context, file, path.toModulePath(), library, typeMap);
                        module = ModuleState.Validated(validTypeMap, file);
                        
                    case Result.Err(errors):
                        context.errors.pushAll(errors);
				}
                
			case ModuleState.Empty:
				// nothing to do
		
			case ModuleState.Validated(_) | ModuleState.Validating(_):
                throw new SourceException("validation has already started");
                
			case ModuleState.Unloaded | ModuleState.Loading(_):
				throw new SourceException("must be loaded");
		}
	}
    
	public function hasModule(context:LoadTypesContext):Bool
	{
		return switch (module)
		{
            case ModuleState.Empty:
                false;
                
			case ModuleState.Loaded(_) | ModuleState.Loading(_) | ModuleState.Validating(_) | ModuleState.Validated(_):
				true;
				
			case ModuleState.Unloaded:
				loadModule(context);
				hasModule(context);
		}
	}
    
	private function getTypeMap(types:Array<TypeDefinition>, filePath:IdlFilePath):Result<Map<String, TypeDefinition>, ReadIdlErrorKind>
	{
		var typeMap:Map<String, TypeDefinition> = new Map<String, TypeDefinition>();
        
		for (type in types)
		{
			var name = TypeDefinitionTools.getTypeName(type);
			if (typeMap.exists(name.toString()))
			{
				var path = new TypePath(Maybe.some(path.toModulePath()), name, name.tag);
				return Result.Err(ReadIdlErrorKind.TypeNameDuplicated(path));
			}
			else
			{
				typeMap.set(name.toString(), type);
			}
		}
		
		return Result.Ok(typeMap);
	}
	
	public function getValidType(context:LoadTypesContext, typeName:TypeName):Maybe<ValidType>
	{
        validateModule(context);
        return switch (module)
		{
			case ModuleState.Validated(data, file):
                switch (data.getMaybe(typeName.toString()).toOption())
                {
                    case Option.None:
                        Maybe.none();
                        
                    case Option.Some(Result.Ok(data)):
                        Maybe.some(data);
                        
                    case Option.Some(Result.Err(errors)):
                        for (error in errors)
                        {
                            context.addError(error);
                        }
                        Maybe.none();
                }
                
			case ModuleState.Empty:
				Maybe.none();
			
			case ModuleState.Unloaded | ModuleState.Loading(_) | ModuleState.Loaded(_) | ModuleState.Validating(_):
                throw new SourceException("must be validated");
		}
	}
    
	public function getTypeDefinition(context:LoadTypesContext, typeName:TypeName):Maybe<TypeDefinition>
	{
		loadModule(context);
        
        return switch (module)
		{
			case ModuleState.Validated(data, file):
                switch data.getMaybe(typeName.toString()).toOption()
                {
                    case Option.None:
                        Maybe.none();
                        
                    case Option.Some(Result.Ok(data)):
                        Maybe.some(data.definition);
                        
                    case Option.Some(Result.Err(errors)):
                        for (error in errors)
                        {
                            context.addError(error);
                        }
                        Maybe.none();
                }
                
			case ModuleState.Loaded(Result.Ok(data), _) | ModuleState.Validating(data, _) | ModuleState.Loading(data, _):
				data.getMaybe(typeName.toString());
				
			case ModuleState.Loaded(Result.Err(errors), _):
                context.errors.pushAll(errors);
                Maybe.none();
                
			case ModuleState.Empty:
				Maybe.none();
                
			case ModuleState.Unloaded:
				throw new SourceException("must be loaded");
		}
	}
	
	private function readIdl(context:LoadTypesContext):Maybe<LoadedIdl>
	{
		return switch (library.readModuleAt(path.toModulePath()))
		{
			case Result.Err(errors):
                for (error in errors)
                {
                    context.addError(error);
                }
                
				Maybe.none();
				
			case Result.Ok(idl):
				idl;
		}
	}
	
	private function containsType(context:LoadTypesContext, restPath:Array<String>, typeName:TypeName):Bool
	{
		return if (restPath.length == 0)
		{
			hasType(context, typeName);
		}
		else
		{
			var head = restPath[0];
			var children = directory.children;
			if (children.exists(head))
			{
				children[head].containsType(context, restPath.slice(1), typeName);
			}
			else
			{
				false;
			}
		}
	}
	
	public function hasType(context:LoadTypesContext, typeName:TypeName):Bool
	{	
		return switch (module)
		{
			case ModuleState.Loaded(Result.Err(errors), file):
                context.errors.pushAll(errors);
                false;
                
			case ModuleState.Empty:
				false;
                
			case ModuleState.Validated(data, file):
				data.exists(typeName.toString());
                
			case ModuleState.Loaded(Result.Ok(data), _) | ModuleState.Loading(data, _) | ModuleState.Validating(data, _):
				data.exists(typeName.toString());
				
			case ModuleState.Unloaded:
				loadModule(context);
				hasType(context, typeName);
		}
	}
	
	public function fetchChildren(context:LoadTypesContext, output:Array<ValidType>):Void
	{
        fetchModule(context, output);
		directory.fetchChildren(context, output);
	}
	
	public function fetchModule(context:LoadTypesContext, output:Array<ValidType>):Void
	{
		validateModule(context);
        
		switch (module)
		{
			case ModuleState.Validated(data, file):
                for (key in data.keys())
				{
                    switch data[key]
                    {
                        case Result.Ok(validType):
                            output.push(validType);
                            
                        case Result.Err(errors):
                            for (error in errors)
                            {
                                context.addError(error);
                            }
                    }
				}
            
            case ModuleState.Loaded(Result.Err(errors), _):
                context.errors.pushAll(errors);
                
			case ModuleState.Empty:
                
			case ModuleState.Unloaded | ModuleState.Loaded(Result.Ok(_), _) | ModuleState.Loading(_) | ModuleState.Validating(_):
                throw new SourceException("must be validated, but " + module);
		}
	}
}
