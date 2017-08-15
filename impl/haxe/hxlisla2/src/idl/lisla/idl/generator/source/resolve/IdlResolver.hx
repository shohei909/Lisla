package lisla.idl.generator.source.resolve;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.idl.generator.error.IdlResolutionError;
import lisla.idl.generator.error.IdlResolutionErrorKind;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.error.LoadIdlErrorKind;
import lisla.idl.generator.error.ModuleNotFoundError;
import lisla.idl.generator.source.file.LoadedModule;
import lisla.idl.library.LibraryResolver;
import lisla.idl.library.LoadTypesContext;
import lisla.idl.library.PackageElement;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.TypeDefinition;
import lisla.project.ProjectRootAndFilePath;

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
