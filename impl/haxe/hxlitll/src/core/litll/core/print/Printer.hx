package lisla.core.print;
import lisla.core.LislaArray;

class Printer
{
	public static function print(array:LislaArray<Lisla>):String
	{
        return "" + array;
	}
    
    public static function printLisla(lisla:Lisla):String
	{
        return "" + lisla;
	}
}
