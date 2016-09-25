package litll.core;
import litll.core.Litll;
import litll.core.tag.Tag;

class LitllTools
{
	public static function getTag(litll:Litll):Tag
	{
		return switch (litll)
		{
			case Litll.Str(data):
				data.tag;

			case Litll.Arr(data):
				data.tag;
		}
	}
}
