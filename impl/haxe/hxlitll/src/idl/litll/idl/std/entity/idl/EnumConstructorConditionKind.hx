package lisla.idl.std.entity.idl;
import lisla.core.LislaString;
import lisla.idl.std.entity.idl.Argument;

enum EnumConstructorConditionKind 
{
    Label(string:LislaString);
    Data(name:ArgumentName, );
    Tuple(argument:Argument);
}
