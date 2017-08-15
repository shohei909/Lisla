package lisla.project;
import lisla.project.FilePathFromProjectRoot;
import sys.FileSystem;
import sys.io.File;

abstract ProjectRootDirectory(String) 
{
    public function new(path:String)
    {
        this = path;
    }
    
    public function searchFiles(baseDirectory:FilePathFromProjectRoot, suffix:String):Array<FilePathFromProjectRoot>
    {
        var result = [];
        _searchFiles(baseDirectory, suffix, result);
        return result;
    }
    
    private function _searchFiles(
        baseDirectory:FilePathFromProjectRoot, 
        suffix:String, 
        result:Array<FilePathFromProjectRoot>
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
    
    public function getContent(path:FilePathFromProjectRoot):String
    {
        return File.getContent(concat(path));
    }
    
    public function readDirectory(path:FilePathFromProjectRoot):Array<String>
    {
        return FileSystem.readDirectory(concat(path));
    }
    
    public function isDirectory(path:FilePathFromProjectRoot):Bool
    {
        return FileSystem.isDirectory(concat(path));
    }
    
    public function exists(path:FilePathFromProjectRoot):Bool
    {
        return FileSystem.exists(concat(path));
    }
    
    public function concat(path:FilePathFromProjectRoot):String
    {
        return this + "/" + path;
    }
    
    public function makePair(filePath:FilePathFromProjectRoot):ProjectRootAndFilePath
    {
        return new ProjectRootAndFilePath(
            new ProjectRootDirectory(this), 
            filePath
        );
    }
}
