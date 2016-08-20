package sora.idl.desoralize;
import haxe.ds.Option;
import sora.core.SoraArray;
import sora.core.SoraString;
import sora.core.ds.SourceRange;

enum DesoralizeErrorTarget 
{
	Str(string:SoraString, range:Option<SourceRange>);
	Arr(array:SoraArray, index:Int);
}