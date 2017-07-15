package lisla.error.core;
import haxe.EnumTools.EnumValueTools;

abstract ErrorName(String) 
{
    public function new (name:String)
    {
        this = name;
    }
    
    public static function fromEnum(kind:EnumValue):ErrorName
    {
        return new ErrorName(Type.getEnumName(Type.getEnum(kind)) + "." + EnumValueTools.getName(kind));
    }
}
