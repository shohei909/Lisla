package arraytree.idl.generator.source.resolve;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.idl.generator.error.IdlResolutionError;
import arraytree.idl.generator.error.IdlResolutionErrorKind;
import arraytree.idl.generator.error.LoadIdlError;
import arraytree.idl.generator.error.LoadIdlErrorKind;
import arraytree.idl.generator.error.ModuleNotFoundError;
import arraytree.idl.generator.source.file.LoadedModule;
import arraytree.idl.library.LibraryResolver;
import arraytree.idl.library.LoadTypesContext;
import arraytree.idl.library.PackageElement;
import arraytree.idl.std.entity.idl.ModulePath;
import arraytree.idl.std.entity.idl.TypeDefinition;
import arraytree.project.ProjectRootAndFilePath;

class IdlResolver
{
	private var idl:LoadedModule;
    private var modulePath:ModulePath;
    private var errors:Array<LoadIdlError>;
	
    public var context(default, null):LoadTypesContext;
    public var library(default, null):LibraryResolver;
    public var element(default, null):PackageElement;
	public var importedElements(default, null):Array<PackageElement>;
	
    public var file(get, never):ProjectRootAndFilePath;
    private function get_file():ProjectRootAndFilePath
    {
        return idl.fileSourceMap.filePath;
    }
    
	public static function run(
        context:LoadTypesContext, 
        element:PackageElement, 
        modulePath:ModulePath, 
        idl:LoadedModule
    ):Void
	{
		var processor = new IdlResolver(context, element, modulePath, idl);
		
		processor.varidatePackagePath();
		processor.processImportedModules();
        
        for (typeDefininition in idl.data.typeDefinitions)
		{
			TypeDefinitionResolver.run(processor, typeDefininition);
		}
	}
	
	private function new(context:LoadTypesContext, element:PackageElement, modulePath:ModulePath, idl:LoadedModule) 
	{
        this.context = context;
        this.element = element;
		this.modulePath = modulePath;
        this.idl = idl;
        this.library = element.library;
        this.errors = [];
    }
	
	private function varidatePackagePath():Void 
	{	
		var packagePath = modulePath.packagePath;
		
        var _packagePath = idl.data.packageDeclaration._package;
        if (packagePath.toString() != _packagePath.toString())
        {
            addError(IdlResolutionErrorKind.InvalidPackage(packagePath, _packagePath));
        }
    }
	
	private function processImportedModules():Void
	{
		importedElements = [element];
		
		for (importTarget in idl.data.importDeclarations)
		{
            switch (parent.library.resolveModuleElement(modulePath))
            {
                case Result.Ok(_library):
                    importedElements.push(element);
                    return;
                    
                case Result.Error(error):
                    addError(IdlResolutionErrorKind.ModuleResolution(error));
            }
		}
	}
	
	public function addError(kind:IdlResolutionErrorKind):Void
	{
		context.errors.push(new IdlResolutionError(kind));
	}
}
