package lisla.type.lisla.type;

abstract Value<T>(T) from T to T
{
    public function new(value:T) 
    {
        this = value;
    }
}
