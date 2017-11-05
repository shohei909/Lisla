package lisla.idl.library;
import haxe.ds.Map;
import haxe.ds.Option;
import hxext.ds.OrderedMap;
import hxext.ds.OrderedMapImpl;
import lisla.data.meta.core.MaybeTag;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeModule;
import lisla.idl.code.library.CodeType;
import lisla.idl.code.library.CodeTypeName;
import lisla.idl.code.tools.EnumDeclarationToCode;
import lisla.idl.code.tools.TupleDeclarationToCode;
import lisla.idl.code.tools.TypeNameDeclarationToCode;
import lisla.idl.error.IdlLibraryErrorKind;
import lisla.idl.error.IdlModuleError;
import lisla.idl.error.IdlModuleError.IdlModuleErrorDetail;
import lisla.idl.error.IdlModuleErrorKind;
import lisla.idl.library.type.TypeDeclaration;
import lisla.idl.library.type.TypeDeclarationTools;
import lisla.type.core.LislaMap;
import lisla.type.lisla.type.Declaration;
import lisla.type.lisla.type.EnumDeclaration;
import lisla.type.lisla.type.ImportDeclaration;
import lisla.type.lisla.type.NewtypeDeclaration;
import lisla.type.lisla.type.StructDeclaration;
import lisla.type.lisla.type.TupleDeclaration;
import lisla.type.lisla.type.TypeName;
import lisla.type.lisla.type.TypeNameDeclaration;
import lisla.type.lisla.type.TypePath;
import lisla.type.lisla.type.UnionDeclaration;
import lisla.type.lisla.type.VariableName;

class IdlModuleBuilder
{
    public var library(default, null):IdlLibraryBuilder;
    public var imports(default, null):Map<TypeName, WithTag<ImportDeclaration>>;
    public var types(default, null):OrderedMap<TypeName, WithTag<TypeDeclaration>>;
    public var tag(default, null):MaybeTag;
    
    public function new(
        library:IdlLibraryBuilder,
        tag:MaybeTag
    )
    {
        this.library = library;
        this.imports = new Map<TypeName, WithTag<ImportDeclaration>>();
        this.types = new OrderedMap<TypeName, WithTag<TypeDeclaration>>();
        this.tag = tag;
    }

    public function addDeclaration(declaration:WithTag<Declaration>):Void
    {        
        inline function withTag<T>(value:T):WithTag<T>
        {
            return declaration.convert(value);
        }
        
        switch (declaration.data)
        {
            case Declaration.Import(value):
                addImport(withTag(value));
                
            case Declaration.Tuple(value):
                addTuple(withTag(value));
                
            case Declaration.Union(value):
                addUnion(withTag(value));
                
            case Declaration.Struct(value):
                addStruct(withTag(value));
                
            case Declaration.Newtype(value):
                addNewtype(withTag(value));
                
            case Declaration.Enum(value):
                addEnum(withTag(value));
        }
    }
    
    public function addImport(declaration:WithTag<ImportDeclaration>):Void
    {
        if (!types.isEmpty())
        {
            addError(
                IdlModuleErrorKind.ImportMustBeHead,
                declaration.tag
            );
        }

        var name = switch (declaration.data.newName)
        {
            case Option.Some(newName):
                newName.data.name.data;
                
            case Option.None:
                declaration.data.path.data.getName();
        }
        
        if (imports.exists(name))
        {
            var another = imports.get(name);
            addError(
                IdlModuleErrorKind.ImportDuplicated(
                    name,
                    another.data.path.data
                ),
                declaration.tag
            );
            addError(
                IdlModuleErrorKind.ImportDuplicated(
                    name,
                    declaration.data.path.data
                ),
                another.tag
            );
        }
        
        imports[name] = declaration;
    }
    
    private function addError(kind:IdlModuleErrorKind, tag:MaybeTag) 
    {
        library.addError(new IdlModuleError(kind, tag.position));
    }
    
    public function addTuple(type:WithTag<TupleDeclaration>):Void
    {
        addType(type.map(TypeDeclaration.Tuple));
    }

    public function addEnum(type:WithTag<EnumDeclaration>):Void
    {
        addType(type.map(TypeDeclaration.Enum));
    }
    
    public function addUnion(type:WithTag<UnionDeclaration>):Void
    {
        addType(type.map(TypeDeclaration.Union));
    }

    public function addNewtype(type:WithTag<NewtypeDeclaration>):Void
    {
        addType(type.map(TypeDeclaration.Newtype));
    }
    
    public function addStruct(type:WithTag<StructDeclaration>):Void
    {
        addType(type.map(TypeDeclaration.Struct));
    }

    public function addType(type:WithTag<TypeDeclaration>):Void
    {
        types.set(TypeDeclarationTools.getName(type.data).data, type);
    }
    
    
    public function getCodeModule(parentContext:LibraryToCodeContext):CodeModule
    {
        var context = new ModuleToCodeContext(
            parentContext,
            this
        );
        var codeTypes = new LislaMap<CodeTypeName, WithTag<CodeType>>();
        for (key in types.keys())
        {
            var type = types[key];
            var codeType = TypeDeclarationTools.toCode(type, context);
            var name = TypeDeclarationTools.getName(type);
            codeTypes.add(name.data.value, name, codeType);
        }
        
        return new CodeModule(codeTypes);
    }
}
