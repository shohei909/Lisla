package lisla.core;
import lisla.core.Lisla;
import hxext.ds.Maybe;
import lisla.core.print.Printer;
import lisla.core.metadata.Tag;

class LislaTools
{
	public static function getTag(lisla:Lisla):Maybe<Tag>
	{
		return switch (lisla)
		{
			case Lisla.Str(data):
				data.metadata.upCast();

			case Lisla.Arr(data):
				data.metadata.upCast();
		}
	}
    
    public static function toString(lisla:Lisla):String
    {
        return Printer.printLisla(lisla);
    }
}
