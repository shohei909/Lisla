package litll.idl.std.data.idl;

enum EnumConstructorHeader 
{
    Basic(name:EnumConstructorName);
    Special(name:EnumConstructorName, condition:EnumConstructorCondition);
}
