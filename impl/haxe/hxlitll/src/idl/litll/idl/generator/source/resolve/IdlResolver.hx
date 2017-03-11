package lisla.idl.generator.source.resolve;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.idl.generator.error.LoadIdlError;
import lisla.idl.generator.error.LoadIdlErrorKind;
import lisla.idl.generator.source.file.IdlFilePath;
import lisla.idl.generator.source.file.LoadedIdl;
import lisla.idl.library.LibraryResolver;
import lisla.idl.library.LoadTypesContext;
import lisla.idl.library.PackageElement;
import lisla.idl.std.entity.idl.ModulePath;
import lisla.idl.std.entity.idl.TypeDefinition;

class IdlResolver
{
	private var idl:LoadedIdl;
    private var modulePath:ModulePath;
    private var errors:Array<LoadIdlError>;
	
    public var context(default, null):LoadTypesContext;
    public var library(default, null):LibraryResolver;
    public var element(default, null):PackageElement;
	public var importedElements(default, null):Array<PackageElement>;
	
    public var file(get, never):IdlFilePath;
    private function get_file():IdlFilePath 
    {
        return idl.file;
    }
    
	public static function run(context:LoadTypesContext, element:PackageElement, modulePath:ModulePath, idl:LoadedIdl, typeMap:Map<String, TypeDefinition>):Result<Map<String, TypeDefinition>, Array<LoadIdlError>>
	{
		var processor = new IdlResolver(context, element, modulePath, idl);
		
		processor.varidatePackagePath();
		processor.processImportedModules();
        
        for (typeDefininition in idl.data.typeDefinitions)
		{
			TypeDefinitionResolver.run(processor, typeDefininition);
		}
        
        return if (processor.errors.length > 0)
        {
            Result.Err(processor.errors);
        }
        else
        {
            Result.Ok(typeMap);
        }
	}
	
	private function new(context:LoadTypesContext, element:PackageElement, modulePath:ModulePath, idl:LoadedIdl) 
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
            addErrorKind(LoadIdlErrorKind.InvalidPackage(packagePath, _packagePath));
        }
    }
	
	private function processImportedModules():Void
	{
		importedElements = [element];
		
		for (importTarget in idl.data.importDeclarations)
		{
            var targetLibrary = switch(library.getReferencedLibrary(file, importTarget.module.libraryName))
            {
                case Result.Ok(_library):
                    _library;
                    
                case Result.Err(errors):
                    addErrors(errors);
                    return;
            }
            
            switch (targetLibrary.getModuleElement(importTarget.module).toOption())
            {
                case Option.Some(element) if (element.hasModule(context)):
                    importedElements.push(element);
                    
                case _:
                    addErrorKind(LoadIdlErrorKind.ModuleNotFound(importTarget.module));
            }
		}
	}
	
    public function addErrorKind(kind:LoadIdlErrorKind):Void
    {
        addError(new LoadIdlError(file, kind));
    }
    
	public function addError(error:LoadIdlError):Void
	{
		errors.push(error);
	}
    
	public function addErrors(errors:Array<LoadIdlError>):Void
	{
		for (error in errors) addError(error);
	}
}
