package litll.idl.std.data.idl;
import litll.core.LitllString;

enum EnumConstructorConditionKind 
{
    Label(string:LitllString);
    Data(name:ArgumentName, );
    Tuple(argument:Argument);
}
