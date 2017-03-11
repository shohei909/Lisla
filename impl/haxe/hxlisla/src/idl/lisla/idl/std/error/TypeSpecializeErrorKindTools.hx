package lisla.idl.std.error;

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