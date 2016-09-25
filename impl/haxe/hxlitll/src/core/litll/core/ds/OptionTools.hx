package litll.core.ds;
import haxe.ds.Option;

class OptionTools
{
	public static inline function getOrThrow<T>(option:Option<T>, ?error:Void->Dynamic):T
	{
		return switch (option)
		{
			case Option.Some(data):
				data;
				
			case Option.None:
				if (error == null)
				{
					throw "Option must be some";
				}
				else
				{
					throw error();
				}
		}
	}
}