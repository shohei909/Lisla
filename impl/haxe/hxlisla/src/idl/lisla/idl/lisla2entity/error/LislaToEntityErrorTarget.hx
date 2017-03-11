package lisla.idl.lisla2entity.error;
import haxe.ds.Option;
import lisla.core.LislaArray;
import lisla.core.LislaString;
import hxext.ds.Maybe;
import lisla.core.ds.SourceRange;
import lisla.core.Lisla;

enum LislaToEntityErrorTarget 
{
	Str(string:LislaString, range:Maybe<SourceRange>);
	Arr(array:LislaArray<Lisla>, index:Int);
}   
