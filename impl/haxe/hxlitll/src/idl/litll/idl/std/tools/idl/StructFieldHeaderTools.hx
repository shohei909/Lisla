package litll.idl.std.tools.idl;
import litll.idl.std.data.idl.EnumConstructorHeader;
import litll.idl.std.data.idl.EnumConstructorName;
import litll.idl.std.data.idl.StructFieldHeader;
import litll.idl.std.data.idl.StructFieldName;

class StructFieldHeaderTools 
{
    public static function getHeaderName(header:StructFieldHeader):StructFieldName
    {
        return switch (header)
        {
            case StructFieldHeader.Primitive(name)
                | StructFieldHeader.Unfold(name):
                name;
        }
    }
}
