package litll.idl.generator.source;
import haxe.ds.Option;
import litll.core.ds.Maybe;
import litll.idl.delitllfy.DelitllfyConfig;
import litll.idl.generator.error.IdlReadError;
import litll.idl.generator.error.IdlReadErrorKind;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.data.idl.path.TypeGroupPath;
using litll.core.ds.MaybeTools;

class RootPackageElement extends PackageElement
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

	public function addError(filePath:String, kind:IdlReadErrorKind):Void
	{
		errors.push(new IdlReadError(filePath, kind));
	}
	
	public function fetchGroups(output:Map<String, TypeDefinition>, targets:Array<TypeGroupPath>):Void
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
					switch (element.getType(typeName).toOption())
					{
						case Option.Some(type):
							var path = new TypePath(Maybe.some(element.getModulePath()), typeName, typeName.tag);
							output[path.toString()] = type;
						
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
}
