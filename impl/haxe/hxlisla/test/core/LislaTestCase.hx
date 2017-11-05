package;
import haxe.PosInfos;
import lisla.data.meta.core.WithTag;
import lisla.data.tree.array.ArrayTreeArray;
import lisla.data.tree.array.ArrayTree;
import nanotest.NanoTestCase;

class LislaTestCase extends NanoTestCase
{
	private function assertTree(tree:WithTag<ArrayTree<String>>, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		switch (tree.data)
		{
			case ArrayTree.Leaf(leaf):
				assertLeaf(leaf, json, path, pos);
			
			case ArrayTree.Arr(array):
				assertArray(array, json, path, pos);
		}
	}
    
	private function assertArray(trees:ArrayTreeArray<String>, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		if (!Std.is(json, Array))
		{
			fail(json + " must be array", pos);
			return;
		}
		
		var jsonArray:Array<Dynamic> = json;
		assertEquals(jsonArray.length, trees.length, pos).label(path + ".length");
		
		for (i in 0...jsonArray.length)
		{
			assertTree(trees[i], jsonArray[i], path + "[" + i + "]", pos);
		}
	}
	
	private function assertLeaf(leaf:String, json:Dynamic, path:String = "_", ?pos:PosInfos):Void
	{
		if (!Std.is(json, String))
		{
			fail(json + " must be string", pos);
			return;
		}
		
		assertEquals(json, leaf, pos).label(path);
	}
}