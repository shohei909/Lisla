package litll.idl.generator.source;
import haxe.ds.Option;
import haxe.io.Path;
import litll.core.ds.Maybe;
import litll.core.ds.Result;
import litll.core.parse.Parser;
import litll.idl.litll2backend.LitllToEntity;
import litll.idl.litll2backend.LitllToEntityConfig;
import litll.idl.generator.error.IdlReadError;
import litll.idl.generator.error.IdlReadErrorKind;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.file.LoadedIdl;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.litll2backend.idl.IdlLitllToEntity;
import sys.FileSystem;
import sys.io.File;

class IdlSourceReader 
{
	public static var suffix = ".idl.litll";
	public var directories(default, null):Array<String>;
	public var config(default, null):LitllToEntityConfig;
	
	public function new (directories:Array<String>, config:LitllToEntityConfig)
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
			var filePath = new IdlFilePath(base + "/" + localPath + ".idl.litll");
            
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
                        for (errorEntry in error.entries)
                        {
                            errorResult(IdlReadErrorKind.Parse(errorEntry));
                        }
						
					case Result.Ok(litllArray):
						switch (LitllToEntity.run(IdlLitllToEntity, litllArray, config))
                        {
							case Result.Err(error):
								errorResult(IdlReadErrorKind.Delitll(error));
								
							case Result.Ok(idl):
								switch (loadedIdl.toOption())
								{
									case Option.Some(prevIdl):
										errorResult(IdlReadErrorKind.ModuleDuplicated(new ModulePath(path), prevIdl.file));
										
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

