package arraytree.idl.std.entity.idl;
import haxe.ds.Option;
import arraytree.data.meta.core.StringWithMetadata;
import hxext.ds.Maybe;
import hxext.ds.Result;
import arraytree.data.meta.core.Metadata;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind;
import arraytree.idl.std.entity.idl.group.TypeGroupPath;

class TypePath
{
	public var modulePath:Maybe<ModulePath>;
	public var typeName:TypeName;
	public var metadata(default, null):Metadata;
    
	public function new(modulePath:Maybe<ModulePath>, typeName:TypeName, metadata:Metadata)
	{
		this.modulePath = modulePath;
		this.typeName = typeName;
		this.metadata = metadata;
	}
	
	@:arraytreeToEntity
	public static function arraytreeToEntity(string:StringWithMetadata):Result<TypePath, ArrayTreeToEntityErrorKind>
	{
		return switch (create(string.data, string.metadata))
		{
			case Result.Ok(data):
				Result.Ok(data);
			
			case Result.Error(data):
				Result.Error(ArrayTreeToEntityErrorKind.Fatal(data));
		}
	}
	
	public static function create(string:String, metadata:Metadata):Result<TypePath, String>
	{
		return createFromArray(string.split("."), metadata);
	}
	
	public static function createFromArray(array:Array<String>, metadata:Metadata):Result<TypePath, String>
	{
		if (array.length == 0)
		{
			return Result.Error("Type array must not be empty.");
		}
		return try 
		{
			var modulePath = if (array.length == 1)
			{
				Maybe.none();
			}
			else
			{
				Maybe.some(new ModulePath(array.slice(0, array.length - 1), metadata));
			}
			var typeNameString = array[array.length - 1];	
			
			Result.Ok(
				new TypePath(modulePath, new TypeName(new StringWithMetadata(typeNameString, metadata)), metadata)
			);
		}
		catch (err:String)
		{
			Result.Error(err);
		}
	}
	
	public function toString():String
	{
		return modulePath.map(function (_modulePath) return _modulePath.toString() + ".").getOrElse("") + typeName.toString();
	}
	
	public function toArray():Array<String>
	{
		return switch (modulePath.toOption())
		{
			case Option.Some(_modulePath):
				_modulePath.toArray().concat([typeName.toString()]);
				
			case Option.None:
				[typeName.toString()];
		}
	}
	
	public function isCoreType():Bool
	{
		return switch (modulePath.toOption())
		{
			case Option.None if (typeName.toString() == "String" || typeName.toString() == "Array"):
				true;
				
			case _:
				false;
		}
	}
    
    public function isStringType():Bool
    {
    	return switch (modulePath.toOption())
		{
			case Option.None if (typeName.toString() == "String"):
				true;
				
			case _:
				false;
		}
    }
	
	public function getModuleArray():Array<String>
	{
		return switch (modulePath.toOption())
		{
			case Option.Some(_modulePath):
				_modulePath.toArray();
				
			case Option.None:
				[];
		}
	}
}
