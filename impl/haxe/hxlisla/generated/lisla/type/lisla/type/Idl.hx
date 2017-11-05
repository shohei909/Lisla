package lisla.type.lisla.type;
import lisla.data.meta.core.WithTag;
import lisla.type.lisla.type.Declaration;

abstract Idl(Array<WithTag<Declaration>>) from Array<WithTag<Declaration>>
{
    public var value(get, never):Array<WithTag<Declaration>>; 
    private function get_value():Array<WithTag<Declaration>> {
        return this;
    }

    public function new(value:Array<WithTag<Declaration>>)
    {
        this = value;
    }
    
    public function unwrap():Array<WithTag<Declaration>>
    {
        return this;
    }
}
