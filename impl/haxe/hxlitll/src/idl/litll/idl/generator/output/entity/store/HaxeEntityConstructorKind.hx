package litll.idl.generator.output.entity.store;

enum HaxeEntityConstructorKind
{
    New;
	Function(name:String, returnKind:HaxeEntityConstructorReturnKind);
}
