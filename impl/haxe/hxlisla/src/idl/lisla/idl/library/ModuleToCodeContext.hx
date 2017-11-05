package lisla.idl.library;
import lisla.data.meta.core.MaybeTag;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeModule;
import lisla.idl.code.library.CodeType;
import lisla.idl.code.library.CodeTypeName;
import lisla.idl.error.IdlLibraryErrorKind;
import lisla.idl.error.IdlModuleError;
import lisla.idl.error.IdlModuleErrorKind;
import lisla.idl.library.type.TypeDeclaration;
import lisla.idl.library.type.TypeDeclarationTools;
import lisla.type.core.LislaMap;
import lisla.type.lisla.type.TypeName;
import lisla.type.lisla.type.TypeNameDeclaration;
import lisla.type.lisla.type.TypePath;
import lisla.type.lisla.type.VariableName;
import lisla.type.lisla.type.VariantName;

class ModuleToCodeContext 
{
    public var library:LibraryToCodeContext;
    public var module:IdlModuleBuilder;
    
    public function new(
        library:LibraryToCodeContext,
        module:IdlModuleBuilder,
        errors:Array<IdlModuleError>
    )
    {
        this.library = library;
        this.module = module;
        this.errors = errors;
    }

    public function run():CodeModule
    {
        var types = new LislaMap<TypeName, WithTag<CodeType>>();
        for (key in module.types.rawKeys)
        {
            var type = module.types[key];
            var name = TypeDeclarationTools.getName(type.data);
            var codeType = TypeDeclarationTools.toCode(type, this);

            types.add(name.data.value, name, codeType);
        }
        
        return new CodeModule(
            new WithTag(
                types,
                module.tag
            )
        );
    }
    
    public function renameVaraiable(data:VariableName):String
    {
        
    }

    public function renameTypePath(data:TypePath):String
    {
        
    }

    public function renameType(name:TypeName):String
    {
        
    }
    
    public function renameVariant(data:VariantName):String
    {
        
    }
    
    public function resolveTypePath(path:TypePath):TypePath
    {
        
    }

    public function resolveTypeNameDeclaration(path:TypePath):TypeNameDeclaration
    {
        
    }
    
    public function addError(kind:IdlModuleErrorKind, tag:MaybeTag):Void
    {
        errors.push(
            IdlLibraryErrorKind.Module(
                new IdlModuleErrorDetail(kind)
            ),
            tag
        );
    }
}
