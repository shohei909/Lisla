package sora.idl.std.data.idl;
import haxe.ds.Option;

class Idl
{
    public var headerTags(default, null):Array<HeaderTag>;
	public var packageDeclaration(default, null):PackageDeclaration;
    public var importDeclarations(default, null):Array<ImportDeclaration>;
    public var typeDefinitions(default, null):Array<TypeDefinition>;
	
	public function new(
		headerTags:Array<HeaderTag>, 
		packageDeclaration:PackageDeclaration, 
		importDeclarations:Array<ImportDeclaration>, 
		typeDefinitions:Array<TypeDefinition>
	)
	{
		this.headerTags = headerTags;
		this.packageDeclaration = packageDeclaration;
		this.importDeclarations = importDeclarations;
		this.typeDefinitions = typeDefinitions;
	}
}
