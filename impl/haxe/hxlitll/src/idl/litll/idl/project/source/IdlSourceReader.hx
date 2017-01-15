package litll.idl.project.source;
import haxe.ds.Option;
import haxe.io.Path;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.parse.Parser;
import litll.idl.delitllfy.Delitllfier;
import litll.idl.delitllfy.DelitllfyConfig;
import litll.idl.project.error.IdlReadError;
import litll.idl.project.error.IdlReadErrorKind;
import litll.idl.std.data.idl.Idl;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.delitllfy.idl.IdlDelitllfier;
import sys.FileSystem;
import sys.io.File;

class IdlSourceReader 
{
	public static var suffix = ".idl.litll";
	public var directories(default, null):Array<String>;
	public var config(default, null):DelitllfyConfig;
	
	public function new (directories:Array<String>, config:DelitllfyConfig)
	{
		this.directories = directories;
		this.config = config;
	}
	
	public function moduleExists(path:Array<String>):Bool
	{
		var localPath = Path.join(path);
		for (base in directories)
		{
			var filePath = base + "/" + localPath + ".idl.litll";
			if (FileSystem.exists(filePath) && !FileSystem.isDirectory(filePath))
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function directoryExists(path:Array<String>):Bool
	{
		var localPath = Path.join(path);
		for (base in directories)
		{
			var dirPath = base + "/" + localPath;
			if (FileSystem.exists(dirPath) && FileSystem.isDirectory(dirPath))
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function readModule(path:Array<String>):Result<Maybe<LoadedIdl>, Array<IdlReadError>>
	{
		var loadedIdl:Maybe<LoadedIdl> = Maybe.none();
		var localPath = Path.join(path);
		var errors = [];
        
		for (base in directories)
		{
			var filePath = base + "/" + localPath + ".idl.litll";
			inline function errorResult(kind:IdlReadErrorKind):Void
			{
				errors.push(new IdlReadError(filePath, kind));
			}
			
			if (FileSystem.exists(filePath) && !FileSystem.isDirectory(filePath))
			{
				var content = File.getContent(filePath);
				switch (Parser.run(content))
				{
					case Result.Err(error):
						errorResult(IdlReadErrorKind.Parse(error));
						
					case Result.Ok(litllArray):
						switch (Delitllfier.run(IdlDelitllfier.process, litllArray, config))
                        {
							case Result.Err(error):
								errorResult(IdlReadErrorKind.Delitll(error));
								
							case Result.Ok(idl):
								switch (loadedIdl.toOption())
								{
									case Option.Some(prevIdl):
										errorResult(IdlReadErrorKind.ModuleDupplicated(new ModulePath(path), prevIdl.file));
										
									case Option.None:
										loadedIdl = Maybe.some(new LoadedIdl(idl, filePath));
								}
						}
				}
			}
		}
		
        return if (errors.length > 0)
        {
            Result.Err(errors);
        }
        else
        {
            Result.Ok(loadedIdl);
        }
	}
	
	public function getChildren(path:Array<String>):Array<String>
	{
		var names = [];
		var localPath = Path.join(path);
		for (base in directories)
		{
			var dirPath = base + "/" + localPath;
			if (FileSystem.exists(dirPath) && FileSystem.isDirectory(dirPath))
			{
				for (childName in FileSystem.readDirectory(dirPath))
				{
					if (!FileSystem.isDirectory(dirPath + "/" + childName))
					{
						if (StringTools.endsWith(childName, suffix))
						{
							childName = childName.substr(0, childName.length - suffix.length);
						}
						else
						{
							continue;
						}
					}
					
					names.push(childName);
				}
			}
		}
		
		return names;
	}
}

