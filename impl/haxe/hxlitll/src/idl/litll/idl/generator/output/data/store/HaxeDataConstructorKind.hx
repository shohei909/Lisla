package litll.idl.generator.output.data.store;

enum HaxeDataConstructorKind
{
    New;
	Function(name:String, returnKind:HaxeDataConstructorReturnKind);
}
