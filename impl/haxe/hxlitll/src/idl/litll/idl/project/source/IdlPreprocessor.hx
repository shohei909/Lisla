package litll.idl.project.source;
import haxe.ds.Option;
import litll.idl.project.error.IdlReadErrorKind;
import litll.idl.project.source.LoadedIdl;
import litll.idl.std.data.idl.ImportDeclaration;
import litll.idl.std.data.idl.ModulePath;
import litll.idl.std.data.idl.TypeDefinition;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypePath;
import litll.idl.std.tools.idl.TypeDefinitionTools;

class IdlPreprocessor
{
	private var idl:LoadedIdl;
	public var element:PackageElement;
	public var importedElements:Array<PackageElement>;
	
	public static function run(element:PackageElement, idl:LoadedIdl):Void
	{
		var processor = new IdlPreprocessor(element, idl);
		
		processor.varidatePackagePath();
		processor.processImportedModules();
		
		for (typeDefininition in idl.data.typeDefinitions)
		{
			TypeDefinitionPreprocessor.run(processor, typeDefininition);
		}
	}
	
	private function new(element:PackageElement, idl:LoadedIdl) 
	{
		this.element = element;
		this.idl = idl;
	}
	
	private function varidatePackagePath():Void 
	{	
		var modulePath = element.getModulePath();
		var packagePath = modulePath.packagePath;
		
        var _packagePath = idl.data.packageDeclaration._package;
        if (packagePath.toString() != _packagePath.toString())
        {
            addError(IdlReadErrorKind.InvalidPackage(packagePath, _packagePath));
        }

	}
	
	private function processImportedModules():Void
	{
		importedElements = [element];
		
		for (importTarget in idl.data.importDeclarations)
		{
            switch (element.root.getElement(importTarget.module.toArray()).toOption())
            {
                case Option.Some(element) if (element.hasModule()):
                    importedElements.push(element);
                    
                case _:
                    addError(IdlReadErrorKind.ModuleNotFound(importTarget.module));
            }
		}
	}
	
	public function addError(kind:IdlReadErrorKind):Void
	{
		element.root.addError(idl.file, kind);
	}
}
