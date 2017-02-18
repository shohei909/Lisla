package litll.idl.generator.source;
import haxe.ds.Option;
import hxext.ds.Maybe;
import hxext.ds.Result;
import litll.idl.exception.IdlException;
import litll.idl.litll2entity.LitllToEntityConfig;
import litll.idl.generator.data.SourceConfig;
import litll.idl.generator.error.IdlReadError;
import litll.idl.generator.error.IdlReadErrorKind;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.group.TypeGroupPath;
using hxext.ds.MaybeTools;

class RootPackageElement extends PackageElement implements IdlSourceProvider
{
	public var reader(default, null):IdlSourceReader;
	public var errors(default, null):Array<IdlReadError>;
	
	public function new(reader:IdlSourceReader) 
	{
		this.reader = reader;
		this.errors = [];
		super(this, []);
	}
	
	public function loadGroup(groupPath:TypeGroupPath):Void
	{
		var pathArray = switch (groupPath.packagePath.toOption())
		{
			case Option.Some(path):
				path.toArray();
				
			case Option.None:
				[];
		}
		
		var packageElement = switch (getElement(pathArray).toOption())
		{
			case Option.Some(data):
				data;
				
			case Option.None:
				return;
		}
		
		if (groupPath.typeName.isSome())
		{
			loadModule();
		}
		else
		{
			loadChildren();
		}
	}

	public function addError(filePath:IdlFilePath, kind:IdlReadErrorKind):Void
	{
		errors.push(new IdlReadError(filePath, kind));
	}
	
	public function fetchGroups(output:Array<ValidType>, targets:Array<TypeGroupPath>):Void
	{
		for (target in targets)
		{
			var element:PackageElement = switch (target.packagePath.toOption())
			{
				case Option.Some(path):
					switch (getElement(path.toArray()).toOption())
					{
						case Option.Some(element):
							element;
							
						case Option.None:
							continue;
					}
					
				case Option.None:
					this;
			}
			
			switch (target.typeName.toOption())
			{
				case Option.Some(typeName):
					switch (element.getValidType(typeName).toOption())
					{
						case Option.Some(type):
							output.push(type);
						
						case Option.None:
					}
					
				case Option.None:
					element.fetchChildren(output);
			}
		}
	}
	
	public function hasError():Bool
	{
		return errors.length > 0;
	}
	
	public function clearErrors():Array<IdlReadError>
	{
		var old = errors;
		errors = [];
		return old;
	}
    
	public function resolveGroups(targets:Array<TypeGroupPath>):Result<Array<ValidType>, Array<IdlReadError>>
	{
		var array = [];
		try 
        {
            fetchGroups(array, targets);
        }
        catch (e:IdlException)
        {
            if (root.hasError())
            {
                return Result.Err(root.clearErrors());
            }
            else
            {
                throw e;
            }
        }
		return if (root.hasError())
		{
			Result.Err(root.clearErrors());
		}
		else
		{
			Result.Ok(array);
		}
	}
    
    public function resolveTypePath(path:TypePath):Maybe<TypeDefinition>
    {
        var element:PackageElement = switch (path.modulePath.toOption())
        {
            case Option.Some(array):
                switch (getElement(array.toArray()).toOption())
                {
                    case Option.None:
                        return Maybe.none();
                        
                    case Option.Some(element):
                        element;
                }
                
            case Option.None:
                root;
        }
        
        return element.getTypeDefinition(path.typeName);
    }
    
    
	public static function create(homeDirectory:String, sourceConfig:SourceConfig):RootPackageElement
	{
		var directories = [homeDirectory + "/std"];
		for (source in sourceConfig.sources)
		{
			directories.push(source);
		}
        
		var reader = new IdlSourceReader(directories, sourceConfig.litllToEntityConfig);
		return new RootPackageElement(reader);
	}
}
