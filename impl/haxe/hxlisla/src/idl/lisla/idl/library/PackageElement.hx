package lisla.idl.library;

import haxe.ds.Option;
import hxext.ds.Maybe;
import hxext.ds.Result;
import lisla.idl.exception.SourceException;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.error.LoadIdlErrorKind;
import lisla.idl.generator.source.DirectoryElement;
import lisla.idl.generator.source.file.IdlFilePath;
import lisla.idl.generator.source.file.LoadedIdl;
import lisla.idl.generator.source.resolve.IdlResolver;
import lisla.idl.generator.source.validate.IdlValidator;
import lisla.idl.generator.source.validate.ValidType;
import lisla.idl.library.ModuleState;
import lisla.idl.std.entity.idl.PackagePath;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.std.tools.idl.TypeDefinitionTools;

using lisla.idl.library.ModuleStateTools;
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
		module = ModuleState.None;
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
            lisla.idl.std.entity.idl.TypeName.create(typeName).getOrThrow()
        );
	}
	
	public function resolveChildren(context:LoadTypesContext):Void
	{
		resolveModule(context);
		directory.resolveChildren(context);
	}
	
	public function resolveModule(context:LoadTypesContext):Void
	{
		if (module.isResolutionStarted()) return;
		
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
                module = ModuleState.Resolved(Result.Err([new LoadIdlError(idl.file, error)]), idl.file);
                return;
        }
        
		module = ModuleState.Resolving(typeMap, idl.file);
		var result = IdlResolver.run(context, this, path.toModulePath(), idl, typeMap);
		module = ModuleState.Resolved(result, idl.file);
	}
    
    public function validateModule(context:LoadTypesContext):Void
    {
		if (module.isValidationStarted()) return;
        
        resolveModule(context);
        
        switch (module)
		{
			case ModuleState.Resolved(loadResult, file):
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
                
			case ModuleState.None | ModuleState.Resolving(_):
				throw new SourceException("must be loaded");
		}
	}
    
	public function hasModule(context:LoadTypesContext):Bool
	{
		return switch (module)
		{
            case ModuleState.Empty:
                false;
                
			case ModuleState.Resolved(_) | ModuleState.Resolving(_) | ModuleState.Validating(_) | ModuleState.Validated(_):
				true;
				
			case ModuleState.None:
				resolveModule(context);
				hasModule(context);
		}
	}
    
	private function getTypeMap(types:Array<TypeDefinition>, filePath:IdlFilePath):Result<Map<String, TypeDefinition>, LoadIdlErrorKind>
	{
		var typeMap:Map<String, TypeDefinition> = new Map<String, TypeDefinition>();
        
		for (type in types)
		{
			var name = TypeDefinitionTools.getTypeName(type);
			if (typeMap.exists(name.toString()))
			{
				var path = new TypePath(Maybe.some(path.toModulePath()), name, name.tag);
				return Result.Err(LoadIdlErrorKind.TypeNameDuplicated(path));
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
			
			case ModuleState.None | ModuleState.Resolving(_) | ModuleState.Resolved(_) | ModuleState.Validating(_):
                throw new SourceException("must be validated");
		}
	}
    
	public function getTypeDefinition(context:LoadTypesContext, typeName:TypeName):Maybe<TypeDefinition>
	{
		resolveModule(context);
        
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
                
			case ModuleState.Resolved(Result.Ok(data), _) | ModuleState.Validating(data, _) | ModuleState.Resolving(data, _):
				data.getMaybe(typeName.toString());
				
			case ModuleState.Resolved(Result.Err(errors), _):
                context.errors.pushAll(errors);
                Maybe.none();
                
			case ModuleState.Empty:
				Maybe.none();
                
			case ModuleState.None:
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
			case ModuleState.Resolved(Result.Err(errors), file):
                context.errors.pushAll(errors);
                false;
                
			case ModuleState.Empty:
				false;
                
			case ModuleState.Validated(data, file):
				data.exists(typeName.toString());
                
			case ModuleState.Resolved(Result.Ok(data), _) | ModuleState.Resolving(data, _) | ModuleState.Validating(data, _):
				data.exists(typeName.toString());
				
			case ModuleState.None:
				resolveModule(context);
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
            
            case ModuleState.Resolved(Result.Err(errors), _):
                context.errors.pushAll(errors);
                
			case ModuleState.Empty:
                
			case ModuleState.None | ModuleState.Resolved(Result.Ok(_), _) | ModuleState.Resolving(_) | ModuleState.Validating(_):
                throw new SourceException("must be validated, but " + module);
		}
	}
}
