package arraytree.core;
import arraytree.core.ArrayTree;
import hxext.ds.Maybe;
import arraytree.core.print.Printer;
import arraytree.core.tag.Tag;

class ArrayTreeTools
{
	public static function getTag(arraytree:ArrayTree):Maybe<Tag>
	{
		return switch (arraytree)
		{
			case ArrayTree.Str(data):
				data.tag.upCast();

			case ArrayTree.Arr(data):
				data.tag.upCast();
		}
	}
    
    public static function toString(arraytree:ArrayTree):String
    {
        return Printer.printArrayTree(arraytree);
    }
}
