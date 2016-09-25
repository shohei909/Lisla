package litll.idl.delitllfy;
import haxe.ds.Option;
import litll.core.LitllArray;
import litll.core.LitllString;
import litll.core.ds.SourceRange;

enum LitllErrorTarget 
{
	Str(string:LitllString, range:Option<SourceRange>);
	Arr(array:LitllArray, index:Int);
}