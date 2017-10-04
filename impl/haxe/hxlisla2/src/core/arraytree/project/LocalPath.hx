package arraytree.project;
import haxe.io.Path;

abstract LocalPath(String) to String
{
    public function new(path:String) 
    {
        this = path;
    }
    
    public function concat(string:String):LocalPath
    {
        return new LocalPath(this + "/" + string);
    }
}
