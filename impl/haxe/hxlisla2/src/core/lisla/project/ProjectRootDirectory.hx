package lisla.project;
import lisla.project.LocalPath;
import sys.FileSystem;
import sys.io.File;

abstract ProjectRootDirectory(String) 
{
    public function new(path:String)
    {
        this = path;
    }
    
    public function searchFiles(baseDirectory:LocalPath, suffix:String):Array<LocalPath>
    {
        var result = [];
        _searchFiles(baseDirectory, suffix, result);
        return result;
    }
    
    private function _searchFiles(
        baseDirectory:LocalPath, 
        suffix:String, 
        result:Array<LocalPath>
    ):Void
    {
        for (fileName in readDirectory(baseDirectory))
        {
            var filePath = baseDirectory.concat(fileName);
            if (isDirectory(filePath))
            {
                _searchFiles(filePath, suffix, result);
            }
            else
            {
                if (StringTools.endsWith(filePath, suffix))
                {
                    result.push(filePath);
                }
            }
        }
    }
    
    public function getContent(path:LocalPath):String
    {
        return File.getContent(concat(path));
    }
    
    public function readDirectory(path:LocalPath):Array<String>
    {
        return FileSystem.readDirectory(concat(path));
    }
    
    public function isDirectory(path:LocalPath):Bool
    {
        return FileSystem.isDirectory(concat(path));
    }
    
    public function exists(path:LocalPath):Bool
    {
        return FileSystem.exists(concat(path));
    }
    
    public function concat(path:LocalPath):String
    {
        return this + "/" + path;
    }
    
    public function makePair(filePath:LocalPath):FullPath
    {
        return new FullPath(
            new ProjectRootDirectory(this), 
            filePath
        );
    }
}
