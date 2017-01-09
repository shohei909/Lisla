package litll.idl.project.output.data.store;

enum HaxeDataConstructorKind
{
    New;
	Function(name:String, returnKind:HaxeDataConstructorReturnKind);
}
