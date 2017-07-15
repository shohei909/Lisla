package lisla.data.meta.position;
import haxe.io.Path;

abstract FilePathFromProjectRoot(String) to String
{
    public function new(path:String) 
    {
        this = path;
    }
    
    public function concat(string:String):FilePathFromProjectRoot
    {
        return new FilePathFromProjectRoot(this + "/" + string);
    }
}
