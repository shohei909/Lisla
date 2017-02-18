package litll.core;
import litll.core.Litll;
import hxext.ds.Maybe;
import litll.core.print.Printer;
import litll.core.tag.Tag;
using hxext.ds.MaybeTools;

class LitllTools
{
	public static function getTag(litll:Litll):Maybe<Tag>
	{
		return switch (litll)
		{
			case Litll.Str(data):
				data.tag.upCast();

			case Litll.Arr(data):
				data.tag.upCast();
		}
	}
    
    public static function toString(litll:Litll):String
    {
        return Printer.printLitll(litll);
    }
}
