package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.Litll;

enum DelitllfyErrorTarget 
{
	Str(string:LitllString, range:Maybe<SourceRange>);
	Arr(array:LitllArray<Litll>, index:Int);
}   
