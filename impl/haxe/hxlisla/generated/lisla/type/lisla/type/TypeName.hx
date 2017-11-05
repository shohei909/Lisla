package lisla.type.lisla.type;
import lisla.type.standard.identifer.UpperCamelIdentifer;

@:forward
abstract TypeName(UpperCamelIdentifer) from String to String
{
    public function new(value:UpperCamelIdentifer)
    {
        this = value;
    }
}
