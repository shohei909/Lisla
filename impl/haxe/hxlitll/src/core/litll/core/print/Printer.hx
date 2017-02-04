package litll.core.print;
import litll.core.LitllArray;

class Printer
{
	public static function print(array:LitllArray<Litll>):String
	{
        return "" + array;
	}
    
    public static function printLitll(litll:Litll):String
	{
        return "" + litll;
	}
}
