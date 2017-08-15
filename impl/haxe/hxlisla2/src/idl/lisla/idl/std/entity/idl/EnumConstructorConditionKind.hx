package lisla.idl.std.entity.idl;
import lisla.data.meta.core.StringWithMetadata;
import lisla.idl.std.entity.idl.Argument;

enum EnumConstructorConditionKind 
{
    Label(string:StringWithMetadata);
    Data(name:ArgumentName, );
    Tuple(argument:Argument);
}
