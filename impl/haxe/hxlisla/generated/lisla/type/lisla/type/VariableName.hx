package lisla.type.lisla.type;
import lisla.type.standard.identifer.LowerSnakeIdentifer;

@:forward
abstract VariableName(LowerSnakeIdentifer)
{
    public function new(value:LowerSnakeIdentifer)
    {
        this = value;
    }
}
