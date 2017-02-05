package litll.idl.std.error;

class ArgumentSuffixErrorKindTools 
{
    public static function toString(kind:ArgumentSuffixErrorKind):String
    {
        return switch(kind)
        {
            case ArgumentSuffixErrorKind.InlineString:
                "string can't be inlined";
                
            case ArgumentSuffixErrorKind.UnsupportedDefault(kind):
                "Default is unsupported for value kind " + kind + ".";
        }
    }   
}
