package;
import litll.core.Litll;
import litll.core.LitllArray;
import litll.core.LitllString;
import haxe.PosInfos;
import nanotest.NanoTestCase;

class LitllTestCase extends NanoTestCase
{
	private function assertLitllArray(litll:LitllArray, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		if (!Std.is(json, Array))
		{
			fail(json + " must be array", pos);
			return;
		}
		
		var jsonArray:Array<Dynamic> = json;
		assertEquals(jsonArray.length, litll.data.length, pos).label(path + ".length");
		
		for (i in 0...jsonArray.length)
		{
			assertLitll(litll.data[i], jsonArray[i], path + "[" + i + "]", pos);
		}
	}
	
	private function assertLitll(litll:Litll, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		switch (litll)
		{
			case Str(str):
				assertLitllString(str, json, path, pos);
			
			case Arr(arr):
				assertLitllArray(arr, json, path, pos);
		}
	}
	
	private function assertLitllString(litll:LitllString, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		if (!Std.is(json, String))
		{
			fail(json + " must be string", pos);
			return;
		}
		
		assertEquals(json, litll.data, pos).label(path);
	}
}