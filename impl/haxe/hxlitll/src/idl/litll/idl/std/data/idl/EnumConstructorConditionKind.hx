package litll.idl.std.data.idl;
import litll.core.LitllString;
import litll.idl.std.data.idl.Argument;

enum EnumConstructorConditionKind 
{
    Label(string:LitllString);
    Data(name:ArgumentName, );
    Tuple(argument:Argument);
}
