package lisla.algorithm;

class SearchTools
{
	public static function binarySearch<T>(array:Array<T>, pivot:Float, evolute:T->Float):Int
	{
		var min = 0;
		var max = array.length;
		while (min < max)
		{
			var center = Std.int((min + max) / 2);
			if (pivot < evolute(array[center]))
			{
				max = center;
			}
			else
			{
				min = center + 1;
			}
		}
		
		return min - 1;
	}
}
