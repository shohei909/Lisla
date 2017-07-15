package file;
import sys.FileSystem;

class FileTools
{
	public static function readRecursively(directory:String):Array<String>
	{
		var result = [];
		for (file in FileSystem.readDirectory(directory))
		{
			var target = directory + "/" + file;
			if (FileSystem.isDirectory(target))
			{
				for (child in readRecursively(target))
				{
					result.push(file + "/" + child);
				}
			}
			else
			{
				result.push(file);
			}
		}
		
		return result;
	}	
}