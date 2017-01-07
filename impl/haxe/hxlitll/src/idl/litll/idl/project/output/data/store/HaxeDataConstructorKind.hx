package litll.idl.project.output.data.store;

enum HaxeDataConstructorKind
{
	Direct(name:String);
	Result(name:String, err:HaxeDataClassConstructorErrorKind);
}
