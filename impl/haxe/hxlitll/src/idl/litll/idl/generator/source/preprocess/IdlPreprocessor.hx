package litll.idl.generator.source.preprocess;
import haxe.ds.Option;
import hxext.ds.Result;
import litll.idl.generator.error.ReadIdlError;
import litll.idl.generator.error.ReadIdlErrorKind;
import litll.idl.generator.source.file.IdlFilePath;
import litll.idl.generator.source.file.LoadedIdl;
import litll.idl.library.LibraryResolver;
import litll.idl.library.LoadTypesContext;
import litll.idl.library.PackageElement;
import litll.idl.std.entity.idl.ModulePath;
import litll.idl.std.entity.idl.TypeDefinition;

class IdlPreprocessor
{
	private var idl:LoadedIdl;
    private var modulePath:ModulePath;
    private var errors:Array<ReadIdlError>;
	
    public var context(default, null):LoadTypesContext;
    public var library(default, null):LibraryResolver;
    public var element(default, null):PackageElement;
	public var importedElements(default, null):Array<PackageElement>;
	
    public var file(get, never):IdlFilePath;
    private function get_file():IdlFilePath 
    {
        return idl.file;
    }
    
	public static function run(context:LoadTypesContext, element:PackageElement, modulePath:ModulePath, idl:LoadedIdl, typeMap:Map<String, TypeDefinition>):Result<Map<String, TypeDefinition>, Array<ReadIdlError>>
	{
		var processor = new IdlPreprocessor(context, element, modulePath, idl);
		
		processor.varidatePackagePath();
		processor.processImportedModules();
        
        for (typeDefininition in idl.data.typeDefinitions)
		{
			TypeDefinitionPreprocessor.run(processor, typeDefininition);
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
            addErrorKind(ReadIdlErrorKind.InvalidPackage(packagePath, _packagePath));
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
                    addErrorKind(ReadIdlErrorKind.ModuleNotFound(importTarget.module));
            }
		}
	}
	
    public function addErrorKind(kind:ReadIdlErrorKind):Void
    {
        addError(new ReadIdlError(file, kind));
    }
    
	public function addError(error:ReadIdlError):Void
	{
		errors.push(error);
	}
    
	public function addErrors(errors:Array<ReadIdlError>):Void
	{
		for (error in errors) addError(error);
	}
}
