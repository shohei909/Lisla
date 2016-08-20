package;
import sora.core.Sora;
import sora.core.SoraArray;
import sora.core.SoraString;
import haxe.PosInfos;
import nanotest.NanoTestCase;

class SoraTestCase extends NanoTestCase
{
	private function assertSoraArray(sora:SoraArray, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		if (!Std.is(json, Array))
		{
			fail(json + " must be array", pos);
			return;
		}
		
		var jsonArray:Array<Dynamic> = json;
		assertEquals(jsonArray.length, sora.data.length, pos).label(path + ".length");
		
		for (i in 0...jsonArray.length)
		{
			assertSora(sora.data[i], jsonArray[i], path + "[" + i + "]", pos);
		}
	}
	
	private function assertSora(sora:Sora, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		switch (sora)
		{
			case Str(str):
				assertSoraString(str, json, path, pos);
			
			case Arr(arr):
				assertSoraArray(arr, json, path, pos);
		}
	}
	
	private function assertSoraString(sora:SoraString, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		if (!Std.is(json, String))
		{
			fail(json + " must be string", pos);
			return;
		}
		
		assertEquals(json, sora.data, pos).label(path);
	}
}