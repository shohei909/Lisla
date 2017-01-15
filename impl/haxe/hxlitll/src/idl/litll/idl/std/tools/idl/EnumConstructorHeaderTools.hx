package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.EnumConstructorHeader;
import litll.idl.std.data.idl.EnumConstructorName;

class EnumConstructorHeaderTools 
{
    public static function getHeaderName(header:EnumConstructorHeader):EnumConstructorName
    {
        return switch (header)
        {
            case EnumConstructorHeader.Basic(name):
                name;
                
            case EnumConstructorHeader.Special(name, _):
                name;
        }
    }   
}