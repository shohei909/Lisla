package lisla.idl.library;
import haxe.ds.Map;
import hxext.ds.Maybe;
import hxext.ds.OrderedMap;
import hxext.ds.Result;
import lisla.data.meta.core.MaybeTag;
import lisla.data.meta.core.WithTag;
import lisla.error.core.Error;
import lisla.idl.code.library.CodeModule;
import lisla.idl.code.library.CodePackagePath;
import lisla.idl.error.IdlLibraryError;
import lisla.idl.error.IdlLibraryErrorKind;
import lisla.idl.error.IdlModuleError;
import lisla.idl.error.IdlModuleErrorKind;
import lisla.idl.code.library.CodeLibrary;
import lisla.idl.library.IdlModuleBuilder;
import lisla.idl.library.LibraryToCodeContext;
import lisla.type.lisla.type.Declaration;
import lisla.type.lisla.type.Idl;
import lisla.type.lisla.type.Declaration;
import lisla.type.lisla.type.TypeName;

class IdlLibraryBuilder
{
    public var modules(default, null):OrderedMap<String, IdlModuleBuilder>;
    public var errors(default, null):Array<IdlModuleError>;
    
    public function new() 
    {
        modules = new OrderedMap();
    }

    public function addModule(moduleName:String, idl:WithTag<Idl>):Void
    {
        var module = new IdlModuleBuilder(this, idl.tag);
        for (declaration in idl.data.value)
        {
            module.addDeclaration(declaration);
        }
    }
    
    public function getCodeLibrary():CodeLibrary
    {
        var context = new LibraryToCodeContext(errors);
        var types = new OrderedMap<CodePackagePath, WithTag<CodeModule>>();
        for (key in modules.rawKeys)
        {
            var module = modules.get(key);
            types.set(
                new CodePackagePath(key), 
                module.getCodeModule(context)
            );
        }
        
        return new CodeLibrary(
            types
        );
    }
    
    public function addError(error:IdlModuleError):Void
    {
        errors.push(error);
    }
}
