// This file is generated by hxlitll.
package litll.idl.std.data.idl;
class Idl {
    public var headerTags : Array<litll.idl.std.data.idl.HeaderTag>;
    public var packageDeclaration : litll.idl.std.data.idl.PackageDeclaration;
    public var importDeclarations : Array<litll.idl.std.data.idl.ImportDeclaration>;
    public var typeDefinitions : Array<litll.idl.std.data.idl.TypeDefinition>;
    public function new(headerTags:Array<litll.idl.std.data.idl.HeaderTag>, packageDeclaration:litll.idl.std.data.idl.PackageDeclaration, importDeclarations:Array<litll.idl.std.data.idl.ImportDeclaration>, typeDefinitions:Array<litll.idl.std.data.idl.TypeDefinition>) {
        this.headerTags = headerTags;
        this.packageDeclaration = packageDeclaration;
        this.importDeclarations = importDeclarations;
        this.typeDefinitions = typeDefinitions;
    }
}