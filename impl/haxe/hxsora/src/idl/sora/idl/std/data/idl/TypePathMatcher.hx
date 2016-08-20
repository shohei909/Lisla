package sora.idl.std.data.idl;
import haxe.ds.Option;
import sora.core.ds.Result;

class TypePathMatcher
{
	private var segments:Array<TypePathMatcherSegment>;
	private var source:String;
	
	private function new(source:String)
	{
		var sourceSegments = source.split(".");
		var l = sourceSegments.length;
		segments = [];
		
		inline function process(string:String, validate:String->Void):Void
		{
			if (string == "*")
			{
				segments.push(TypePathMatcherSegment.RigidWildcard);
			}
			else if (string == "**")
			{
				segments.push(TypePathMatcherSegment.FlexWildcard);
			}
			else 
			{
				validate(string);
				segments.push(string);
			}
		}
		for (i in 0...(l-1))
		{
			process(sourceSegments[i], PackagePath.validateElement);
		}
		{
			process(sourceSegments[l - 1], TypeName.validate);
		}
		
		this.source = source;
	}
	
	public function match(typePath:TypePath):Option<Array<Array<String>>>
	{
		
	}
	
	public static function create(string:String):Result<TypePathMatcher, String>
	{
		return try 
		{
			Result.Ok(new TypePathMatcher(string));
		}
		catch (err:String)
		{
			Result.Err(err);
		}
	}
	
	public function toString():String
	{
		return source;
	}
}

private enum TypePathMatcherSegment
{
	RigidWildcard;
	FlexWildcard;
	Str(string:String);
}