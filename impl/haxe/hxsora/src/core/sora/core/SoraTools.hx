package sora.core;
import sora.core.Sora;
import sora.core.tag.Tag;

class SoraTools
{
	public static function getTag(sora:Sora):Tag
 	{
		return switch (sora)
		{
			case Sora.Str(data):
				data.tag;
				
			case Sora.Arr(data):
				data.tag;
		}
	}
}
