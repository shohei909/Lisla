package lisla.idl.generator.output.entity.store;

enum HaxeEntityConstructorKind
{
    New;
	Function(name:String, returnKind:HaxeEntityConstructorReturnKind);
}
