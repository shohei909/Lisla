package litll.core;
import litll.core.Litll;
import litll.core.ds.Maybe;
import litll.core.print.Printer;
import litll.core.tag.Tag;
using litll.core.ds.MaybeTools;

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
