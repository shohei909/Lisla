package litll.idl.std.entity.idl;
import litll.core.LitllString;
import litll.idl.std.entity.idl.Argument;

enum EnumConstructorConditionKind 
{
    Label(string:LitllString);
    Data(name:ArgumentName, );
    Tuple(argument:Argument);
}
