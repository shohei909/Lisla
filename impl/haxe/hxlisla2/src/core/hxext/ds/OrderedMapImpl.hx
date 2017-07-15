package hxext.ds;
import haxe.ds.StringMap;

class OrderedMapImpl<Key, Value>
{
    public var rawKeys(default, null):Array<Key>;
    public var map(default, null):Map<Key, Value>;
    
    public function new(map:Map<Key, Value>) 
    {
        rawKeys = [];
        this.map = map;
    }
    
    public function exists(key:Key):Bool
    {
        return map.exists(key);
    }
    
    public function set(key:Key, value:Value):Void
    {
        if (!map.exists(key))
        {
            rawKeys.push(key);
            map.set(key, value);
        }
    }
    
    public function push(key:Key, value:Value):Void
    {
        if (map.exists(key))
        {
            remove(key);
        }
        
        rawKeys.push(key);
        map.set(key, value);
    }
    
    public function get(key:Key):Value
    {
        return map.get(key);
    }
    
    public function removeAt(index:Int):Bool
    {
        if (index < 0 || rawKeys.length <= index) return false;
        
        var removedKey = rawKeys.splice(index, 1)[0];
        map.remove(removedKey);
        return true;
    }
    
    public function remove(key:Key):Bool
    {
        return if (rawKeys.remove(key))
        {
            map.remove(key);
            true;
        }
        else
        {
            false;
        }
    }
    
    public function keys():Array<Key>
    {
        return rawKeys.copy();
    }
}
