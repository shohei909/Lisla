package lisla.core.string;
import hxext.ds.Result;

class IdentifierTools
{
	private static var keywords = [
		"function", "class", "static", "var", "if", "else", "while", "do", "for", 
		"break", "return", "continue", "extends", "implements", "import", 
		"switch", "case", "default", "public", "private", "try", "untyped", 
		"catch", "new", "this", "throw", "extern", "enum", "in", "interface", 
		"cast", "override", "dynamic", "typedef", "package", 
		"inline", "using", "null", "true", "false", "abstract"
	];
	
	private static var convertableEReg:EReg = ~/[_a-zA-Z][_a-zA-Z0-9]*/;
	private static var snakeCaseEReg:EReg = ~/[_a-z]+/;
	private static var escapeTarget:EReg = new EReg("^_*((" + keywords.join(")|(") + "))$", "");
	
	public static function toPascalCase(snakeCaseString:String):Result<String, String>
	{
		if (!convertableEReg.match(snakeCaseString))
		{
			return Result.Err("failed convert " + snakeCaseString + " to PascalCase");
		}

		var segments = snakeCaseString.split("_");
		var result = "";
		
		for (segment in segments)
		{
			if (segment.length == 0)
			{
				continue;
			}
			
			result += segment.substr(0, 1).toUpperCase() + segment.substr(1);
		}
		
		return Result.Ok(result);
	}
	
	public static function toCamelCase(snakeCaseString:String):Result<String, String>
	{
		if (!convertableEReg.match(snakeCaseString))
		{
			return Result.Err("failed convert " + snakeCaseString + " to cascalCase");
		}

		var segments = snakeCaseString.split("_");
		var result = "";
		var isFirst = true;
		
		for (segment in segments)
		{
			if (segment.length == 0)
			{
				continue;
			}
			
			if (isFirst)
			{
				result += segment.substr(0, 1).toLowerCase() + segment.substr(1);
				isFirst = false;
			}
			else
			{
				result += segment.substr(0, 1).toUpperCase() + segment.substr(1);
			}
		}
		
		return Result.Ok(result);
	}
	
	public static function isSnakeCase(string:String):Bool
	{
		return snakeCaseEReg.match(string);
	}
	
	public static function escapeKeyword(string:String):String
	{
		return if (escapeTarget.match(string))
		{
			"_" + string;
		}
		else
		{
			string;
		}
	}
}
