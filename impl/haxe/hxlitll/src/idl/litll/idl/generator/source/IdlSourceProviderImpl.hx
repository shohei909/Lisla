package litll.idl.generator.source;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.idl.delitllfy.DelitllfyConfig;
import litll.idl.generator.error.IdlReadError;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.path.TypeGroupPath;
import litll.idl.generator.data.SourceConfig;

class IdlSourceProviderImpl implements IdlSourceProvider
{
	public var directories(default, null):Array<String>;
	public var root(default, null):RootPackageElement;
	
	public function new(homeDirectory:String, sourceConfig:SourceConfig) 
	{
		directories = [homeDirectory + "/std"];
		for (source in sourceConfig.sources)
		{
			directories.push(source);
		}
		
		var reader = new IdlSourceReader(directories, sourceConfig.delitllfyConfig);
		root = new RootPackageElement(reader);
	}
	
	public function resolveGroups(targets:Array<TypeGroupPath>):Result<Map<String, TypeDefinition>, Array<IdlReadError>>
	{
		var map = new Map();
		root.fetchGroups(map, targets);
		
		return if (root.hasError())
		{
			Result.Err(root.clearErrors());
		}
		else
		{
			Result.Ok(map);
		}
	}
    
    public function resolveTypePath(path:TypePath):Maybe<TypeDefinition>
    {
        var element:PackageElement = switch (path.modulePath.toOption())
        {
            case Option.Some(array):
                switch (root.getElement(array.toArray()).toOption())
                {
                    case Option.None:
                        return Maybe.none();
                        
                    case Option.Some(element):
                        element;
                }
                
            case Option.None:
                root;
        }
        
        return element.getType(path.typeName);
    }
}
