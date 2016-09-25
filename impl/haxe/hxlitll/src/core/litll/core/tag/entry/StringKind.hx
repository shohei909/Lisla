package litll.core.tag.entry;

enum StringKind 
{
	Quoted(singleQuoted:Bool, quoteCount:Int);
	Unquoded;
}