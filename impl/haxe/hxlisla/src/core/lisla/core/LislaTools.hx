package lisla.core;
import lisla.core.Lisla;
import hxext.ds.Maybe;
import lisla.core.print.Printer;
import lisla.core.tag.Tag;

class LislaTools
{
	public static function getTag(lisla:Lisla):Maybe<Tag>
	{
		return switch (lisla)
		{
			case Lisla.Str(data):
				data.tag.upCast();

			case Lisla.Arr(data):
				data.tag.upCast();
		}
	}
    
    public static function toString(lisla:Lisla):String
    {
        return Printer.printLisla(lisla);
    }
}
