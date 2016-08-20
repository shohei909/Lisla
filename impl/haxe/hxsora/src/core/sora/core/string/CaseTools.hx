package sora.core.string;
import sora.core.ds.Result;

class CaseTools
{
	private static var eReg:EReg = ~/[_a-zA-Z][_a-zA-Z0-9]*/;
	
	public static function toPascalCase(snakeCaseString:String):Result<String, String>
	{
		if (eReg.match(snakeCaseString))
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
		if (eReg.match(snakeCaseString))
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
			}
			else
			{
				result += segment.substr(0, 1).toUpperCase() + segment.substr(1);
			}
		}
		
		return Result.Ok(result);
	}
}
