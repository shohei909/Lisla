package;
import lisla.core.Lisla;
import lisla.core.LislaArray;
import lisla.core.LislaString;
import haxe.PosInfos;
import nanotest.NanoTestCase;

class LislaTestCase extends NanoTestCase
{
	private function assertLislaArray(lisla:LislaArray<Lisla>, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		if (!Std.is(json, Array))
		{
			fail(json + " must be array", pos);
			return;
		}
		
		var jsonArray:Array<Dynamic> = json;
		assertEquals(jsonArray.length, lisla.data.length, pos).label(path + ".length");
		
		for (i in 0...jsonArray.length)
		{
			assertLisla(lisla.data[i], jsonArray[i], path + "[" + i + "]", pos);
		}
	}
	
	private function assertLisla(lisla:Lisla, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		switch (lisla)
		{
			case Str(str):
				assertLislaString(str, json, path, pos);
			
			case Arr(arr):
				assertLislaArray(arr, json, path, pos);
		}
	}
	
	private function assertLislaString(lisla:LislaString, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		if (!Std.is(json, String))
		{
			fail(json + " must be string", pos);
			return;
		}
		
		assertEquals(json, lisla.data, pos).label(path);
	}
}