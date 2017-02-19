package litll.idl.litll2entity.error;
import haxe.ds.Option;
import litll.core.LitllArray;
import litll.core.LitllString;
import hxext.ds.Maybe;
import litll.core.ds.SourceRange;
import litll.core.Litll;

enum LitllToEntityErrorTarget 
{
	Str(string:LitllString, range:Maybe<SourceRange>);
	Arr(array:LitllArray<Litll>, index:Int);
}   