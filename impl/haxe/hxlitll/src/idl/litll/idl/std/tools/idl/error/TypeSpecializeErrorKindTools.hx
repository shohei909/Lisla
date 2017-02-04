package litll.idl.std.tools.idl.error;

class TypeSpecializeErrorKindTools
{
    public static function toString(error:TypeSpecializeErrorKind):String
    {
        return switch(error)
        {
            case TypeSpecializeErrorKind.InvalidTypeParameterLength(expected, actual):
                "invalid type parameters length. " + expected + " expected, but actual " + actual;
        }
    }
}