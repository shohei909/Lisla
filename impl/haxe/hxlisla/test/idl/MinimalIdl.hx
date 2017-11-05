package;
import haxe.ds.Option;
import hxext.ds.Maybe;
import lisla.data.meta.core.WithTag;
import lisla.data.tree.array.ArrayTree;
import lisla.idl.library.IdlLibraryBuilder;
import lisla.type.lisla.type.Declaration;
import lisla.type.lisla.type.GenericTypeDeclaration;
import lisla.type.lisla.type.GenericTypeReference;
import lisla.type.lisla.type.Idl;
import lisla.type.lisla.type.LabelElement;
import lisla.type.lisla.type.NewtypeDeclaration;
import lisla.type.lisla.type.StructDeclaration;
import lisla.type.lisla.type.StructElement;
import lisla.type.lisla.type.StructVarAttributes;
import lisla.type.lisla.type.StructVarElement;
import lisla.type.lisla.type.StructVarNest;
import lisla.type.lisla.type.TupleDeclaration;
import lisla.type.lisla.type.TupleElement;
import lisla.type.lisla.type.TupleVarAttributes;
import lisla.type.lisla.type.TupleVarElement;
import lisla.type.lisla.type.TupleVarNest;
import lisla.type.lisla.type.TypeArgument;
import lisla.type.lisla.type.TypeName;
import lisla.type.lisla.type.TypeNameDeclaration;
import lisla.type.lisla.type.TypeParameterDeclaration;
import lisla.type.lisla.type.TypeParameterDeclarationAttributes;
import lisla.type.lisla.type.TypePath;
import lisla.type.lisla.type.TypeReference;
import lisla.type.lisla.type.TypeTypeParameterDeclaration;
import lisla.type.lisla.type.UnionCaseAttributes;
import lisla.type.lisla.type.UnionCaseElement;
import lisla.type.lisla.type.UnionCaseHeader;
import lisla.type.lisla.type.UnionDeclaration;
import lisla.type.lisla.type.UnionElement;
import lisla.type.lisla.type.VarRule;
import lisla.type.lisla.type.VariableName;
import lisla.type.lisla.type.VariantName;

class MinimalIdl 
{
    public static function getLibrary():IdlLibraryBuilder
    {
        var library = new IdlLibraryBuilder();
        library.addModule("core",       new Idl(coreIdl()));
        library.addModule("lisla.type", new Idl(idlIdl()));
        return library;
    }
    
    public static function coreIdl():Array<WithTag<Declaration>>
    {
        return [];
    }
    
    public static function idlIdl():Array<WithTag<Declaration>>
    {
        return [
            // ----------------------------------------------------------------------
            // Declaration
            // ----------------------------------------------------------------------
            Declaration.Newtype(
                new NewtypeDeclaration(
                    primitiveTypeDecl("Idl"),
                    genericType("Array", "Declaration")
                )
            ),
            union(
                primitiveTypeDecl("Declaration"),
                [
                    unionCaseWithLabel("Import", "ImportDeclaration", "import"),
                    unionCaseWithLabel("Tuple", "TupleDeclaration", "tuple"),
                    unionCaseWithLabel("Union", "UnionDeclaration", "union"),
                    unionCaseWithLabel("Struct", "StructDeclaration", "struct"),
                    unionCaseWithLabel("Newtype", "NewtypeDeclaration", "newtype"),
                    unionCaseWithLabel("Enum", "EnumDeclaration", "enum"),
                ]
            ),
            
            // ----------------------------------------------------------------------
            // Name
            // ----------------------------------------------------------------------
            newtype("TypePath", "String"),
            newtype("VariableName", "String"),
            newtype("TypeName", "String"),
            newtype("VariantName", "String"),
            
            Declaration.Newtype(
                new NewtypeDeclaration(
                    genericTypeDecl("Value", "T"),
                    primitiveType("Any")
                )
            ),
            
            // ----------------------------------------------------------------------
            // Type Reference
            // ----------------------------------------------------------------------
            union(
                primitiveTypeDecl("TypeReference"),
                [
                    unionCase("Primitive", "TypePath"),
                    unionCase("Generic", "GenericTypeReference"),
                ]
            ),
            tuple(
                primitiveTypeDecl("GenericTypeReference"),
                [
                    tupleVar("name", "TypePath"),
                    tupleVarWithRule("arguments", "TypeArgument", VarRule.Repeated),
                ]
            ),
            Declaration.Newtype(
                new NewtypeDeclaration(
                    primitiveTypeDecl("TypeArgument"),
                    genericType("Value", "Any")
                )
            ),
            
            // ----------------------------------------------------------------------
            // Type TypeDeclaration
            // ----------------------------------------------------------------------
            union(
                primitiveTypeDecl("TypeDeclaration"),
                [
                    unionCase("Primitive", "TypeName"),
                    unionCase("Generic", "GenericTypeDeclaration"),
                ]
            ),
            tuple(
                primitiveTypeDecl("GenericTypeDeclaration"),
                [
                    tupleVar("name", "TypeName"),
                    tupleVarWithRule("parameters", "TypeParameterDeclaration", VarRule.Repeated),
                ]
            ),
            union(
                primitiveTypeDecl("TypeParameterDeclaration"),
                [
                    unionCaseWithLabel("Value", "ValueTypeParameterDeclaration", "value"),
                    unionCaseWithLabel("Type", "TypeTypeParameterDeclaration", "type"),
                ]
            ),
            tuple(
                primitiveTypeDecl("ValueTypeParameterDeclaration"),
                [
                    tupleVar("name", "VariableName"),
                    TupleElement.Label(new LabelElement(":")),
                    tupleVar("type", "TypeReference"),
                    tupleSpreadVar("attributes", "TypeParameterDeclarationAttributes"),
                ]
            ),
            tuple(
                primitiveTypeDecl("TypeTypeParameterDeclaration"),
                [
                    tupleVar("name", "TypeName"),
                    tupleSpreadVar("attributes", "TypeParameterDeclarationAttributes"),
                ]
            ),
            struct(
                primitiveTypeDecl("TypeParameterDeclarationAttributes"),
                [
                    structOptionalSpreadVar("rule", "VarRule")
                ]
            ),
            
            // ----------------------------------------------------------------------
            // Import
            // ----------------------------------------------------------------------
            tuple(
                primitiveTypeDecl("ImportDeclaration"),
                [
                    TupleElement.Label(new LabelElement("package")),
                    tupleVar("path", "TypePath"),
                    tupleOptionalSpreadVar("as", "ImportAsAttribute"),
                ]
            ),
            tuple(
                primitiveTypeDecl("ImportAsAttribute"),
                [
                    TupleElement.Label(new LabelElement("as")),
                    tupleVar("name", "TypeName"),
                ]
            ),
            
            // ----------------------------------------------------------------------
            // Struct
            // ----------------------------------------------------------------------
            tuple(
                primitiveTypeDecl("StructDeclaration"),
                [
                    tupleVar("name", "TypeDeclaration"),
                    tupleRepeatedVar("elements", "StructElement"),
                ]
            ),
            union(
                primitiveTypeDecl("StructElement"),
                [
                    unionCaseWithLabel("Extends", "ExtendsElement", "extends"),
                    unionCaseWithLabel("Const", "ConstElement", "const"),
                    unionCaseWithLabel("Var", "StructVarElement", "var"),
                ]
            ),
            tuple(
                primitiveTypeDecl("ExtendsElement"),
                [
                    tupleVar("name", "VariableName"),
                    TupleElement.Label(new LabelElement(":")),
                    tupleVar("type", "TypeReference"),
                ]
            ),
            tuple(
                primitiveTypeDecl("ConstElement"),
                [
                    tupleVar("name", "String"),
                    TupleElement.Label(new LabelElement(":")),
                    TupleElement.Var(
                        new TupleVarElement(
                            new VariableName("value"),
                            genericType("Value", "T"),
                            TupleVarAttributes.empty()
                        )
                    )
                ]
            ),
            tuple(
                primitiveTypeDecl("StructVarElement"),
                [
                    tupleVar("name", "VariableName"),
                    TupleElement.Label(new LabelElement(":")),
                    tupleVar("type", "TypeReference"),
                    tupleSpreadVar("attributes", "StructVarAttributes"),
                ]
            ),
            struct(
                primitiveTypeDecl("StructVarAttributes"),
                [
                    structOptionalForwardVar("rule", "VarRule"),
                    structOptionalForwardVar("rule", "StructVarNest"),
                ]
            ),
            union(
                primitiveTypeDecl("VarRule"),
                [
                    unionConstCase("Optional", "optional"),
                    unionConstCase("Repeated", "repeated"),
                ]
            ),
            struct(
                primitiveTypeDecl("StructVarAttributes"),
                [
                    structOptionalForwardVar("rule", "VarRule"),
                    structOptionalForwardVar("nest", "StructVarNest"),
                ]
            ),
            union(
                primitiveTypeDecl("StructVarNest"),
                [
                    unionConstCase("Spread", "spread"),
                    unionConstCase("Forward", "forward"),
                ]
            ),
            
            // ----------------------------------------------------------------------
            // Union
            // ----------------------------------------------------------------------
            tuple(
                primitiveTypeDecl("UnionDeclaration"),
                [
                    tupleVar("name", "TypeDeclaration"),
                    tupleRepeatedVar("elements", "UnionElement"),
                ]
            ),
            union(
                primitiveTypeDecl("UnionElement"),
                [
                    unionCaseWithLabel("Case", "UnionCaseElement", "case"),
                ]
            ),
            tuple(
                primitiveTypeDecl("UnionCaseElement"),
                [
                    tupleVar("name", "VariantName"),
                    TupleElement.Label(new LabelElement(":")),
                    tupleVar("type", "TypeReference"),
                    tupleSpreadVar("attributes", "UnionCaseAttributes"),
                ]
            ),
            struct(
                primitiveTypeDecl("UnionCaseAttributes"),
                [
                    structRepeatedForwardVar("headers", "UnionCaseHeader"),
                ]
            ),
            union(
                primitiveTypeDecl("UnionCaseHeader"),
                [
                    unionCaseWithLabel("Label", "LabelElement", "label"),
                    unionCaseWithLabel("Const", "ConstElement", "const"),
                ]
            ),
            
            // ----------------------------------------------------------------------
            // Tuple
            // ----------------------------------------------------------------------
            tuple(
                primitiveTypeDecl("TupleDeclaration"),
                [
                    tupleVar("name", "TypeDeclaration"),
                    tupleRepeatedVar("elements", "TupleElement"),
                ]
            ),
            union(
                primitiveTypeDecl("TupleElement"),
                [
                    unionCaseWithLabel("Label", "LabelElement", "label"),
                    unionCaseWithLabel("Var", "TupleVarElement", "var"),
                ]
            ),
            tuple(
                primitiveTypeDecl("LabelElement"),
                [
                    tupleVar("name", "String"),
                ]
            ),
            tuple(
                primitiveTypeDecl("TupleVarElement"),
                [
                    tupleVar("name", "VariableName"),
                    TupleElement.Label(new LabelElement(":")),
                    tupleVar("type", "TypeReference"),
                    tupleSpreadVar("attributes", "TupleVarAttributes"),
                ]
            ),
            struct(
                primitiveTypeDecl("TupleVarAttributes"),
                [
                    structOptionalForwardVar("rule", "VarRule"),
                    structOptionalForwardVar("rule", "TupleVarNest"),
                ]
            ),
            union(
                primitiveTypeDecl("TupleVarNest"),
                [
                    unionConstCase("Spread", "spread"),
                ]
            ),
            
            // ----------------------------------------------------------------------
            // Newtype
            // ----------------------------------------------------------------------
            tuple(
                primitiveTypeDecl("NewtypeDeclaration"),
                [
                    tupleVar("name", "TypeDeclaration"),
                    TupleElement.Label(new LabelElement(":")),
                    tupleVar("underly_type", "TypeReference"),
                ]
            ),
            
            // ----------------------------------------------------------------------
            // Enum
            // ----------------------------------------------------------------------
            tuple(
                primitiveTypeDecl("NewtypeDeclaration"),
                [
                    tupleVar("name", "TypeDeclaration"),
                    tupleRepeatedVar("underly_type", "TypeReference"),
                ]
            ),
            union(
                primitiveTypeDecl("EnumElement"),
                [
                    unionCaseWithLabel("Case", "EnumCaseElement", "case"),
                ]
            ),
            tuple(
                primitiveTypeDecl("EnumCaseElement"),
                [
                    tupleVar("name", "VariableName"),
                    tupleSpreadVar("attributes", "EnumCaseAttributes"),
                ]
            ),
            struct(
                primitiveTypeDecl("EnumCaseAttributes"),
                [
                ]
            ),
        ];
    }
    
    
    private static function newtype(decl:String, ref:String):Declaration
    {
        return Declaration.Newtype(
            new NewtypeDeclaration(
                primitiveTypeDecl(decl),
                primitiveType(ref)
            )
        );
    }
    private static function tuple(
        typeDecl:TypeNameDeclaration, 
        array:Array<WithTag<TupleElement>>
    ):Declaration
    {
        return Declaration.Tuple(new TupleDeclaration(typeDecl, array));
    }
    private static function struct(
        typeDecl:TypeNameDeclaration, 
        array:Array<WithTag<StructElement>>
    ):Declaration
    {
        return Declaration.Struct(new StructDeclaration(typeDecl, array));
    }
    private static function union(
        typeDecl:TypeNameDeclaration, 
        array:Array<WithTag<UnionElement>>
    ):Declaration
    {
        return Declaration.Union(new UnionDeclaration(typeDecl, array));
    }
    
    private static function primitiveTypeDecl(name:String):TypeNameDeclaration
    {
        return TypeNameDeclaration.Primitive(
            new TypeName(name)
        );
    }
    
    private static function genericTypeDecl(name:String, childType:String):TypeNameDeclaration
    {
        return TypeNameDeclaration.Generic(
            new GenericTypeDeclaration(
                new TypeName(name),
                [
                    TypeParameterDeclaration.Type(
                        new TypeTypeParameterDeclaration(
                            new TypeName(childType),
                            new TypeParameterDeclarationAttributes(
                                Option.None
                            )
                        )
                    ),
                ]
            )
        );
    }

    private static function primitiveType(name:String):TypeReference
    {
        return TypeReference.Primitive(
            new TypePath(name)
        );
    }
    
    private static function genericType(name:String, childType:String):TypeReference
    {
        return TypeReference.Generic(
            new GenericTypeReference(
                new TypePath(name), 
                [
                    new TypeArgument(
                        ArrayTree.Leaf(childType)
                    ),
                ]
            )
        );
    }
    
    private static function unionCase(
        caseName:String,
        typeName:String
    ):UnionElement
    {
        return UnionElement.Case(
            new UnionCaseElement(
                new VariantName(caseName),
                primitiveType(typeName),
                new UnionCaseAttributes(
                    [],
                    Maybe.none()
                )
            )
        );
    }

    private static function unionConstCase(
        caseName:String,
        value:String
    ):UnionElement
    {
        return UnionElement.Case(
            new UnionCaseElement(
                new VariantName(caseName),
                genericType("Const", value),
                new UnionCaseAttributes(
                    [],
                    Maybe.none()
                )
            )
        );
    }

    private static function unionCaseWithLabel(
        caseName:String,
        typeName:String,
        label:String
    ):UnionElement
    {
        return UnionElement.Case(
            new UnionCaseElement(
                new VariantName(caseName),
                primitiveType(typeName),
                new UnionCaseAttributes(
                    [
                        UnionCaseHeader.Label(new LabelElement(label))
                    ],
                    Maybe.none()
                )
            )
        );
    }
        
    private static function tupleVar(name:String, typeName:String):TupleElement
    {
        return TupleElement.Var(
            new TupleVarElement(
                new VariableName(name),
                primitiveType(typeName),
                TupleVarAttributes.empty()
            )
        );
    }
    
    private static function tupleVarWithRule(name:String, typeName:String, rule:VarRule):TupleElement
    {
        return TupleElement.Var(
            new TupleVarElement(
                new VariableName(name),
                primitiveType(typeName),
                new TupleVarAttributes(
                    Option.Some(rule),
                    Option.None,
                    Option.None
                )
            )
        );
    }
    
    private static function tupleSpreadVar(name:String, typeName:String):TupleElement
    {
        return TupleElement.Var(
            new TupleVarElement(
                new VariableName(name),
                primitiveType(typeName),
                new TupleVarAttributes(
                    Option.None,
                    Option.Some(TupleVarNest.Spread),
                    Option.None
                )
            )
        );
    }
    
    private static function tupleOptionalSpreadVar(name:String, typeName:String):TupleElement
    {
        return TupleElement.Var(
            new TupleVarElement(
                new VariableName(name),
                primitiveType(typeName),
                new TupleVarAttributes(
                    Option.Some(VarRule.Optional),
                    Option.Some(TupleVarNest.Spread),
                    Option.None
                )
            )
        );
    }
    
    private static function tupleRepeatedVar(name:String, typeName:String):TupleElement
    {
        return TupleElement.Var(
            new TupleVarElement(
                new VariableName(name),
                primitiveType(typeName),
                new TupleVarAttributes(
                    Option.Some(VarRule.Repeated),
                    Option.None,
                    Option.None
                )
            )
        );
    }
    
    private static function structRepeatedForwardVar(name:String, typeName:String):StructElement
    {
        return StructElement.Var(
            new StructVarElement(
                new VariableName(name),
                primitiveType(typeName),
                new StructVarAttributes(
                    Option.Some(VarRule.Repeated),
                    Option.Some(StructVarNest.Forward),
                    Option.None
                )
            )
        );
    }

    private static function structOptionalSpreadVar(name:String, typeName:String):StructElement
    {
        return StructElement.Var(
            new StructVarElement(
                new VariableName(name),
                primitiveType(typeName),
                new StructVarAttributes(
                    Option.Some(VarRule.Optional),
                    Option.Some(StructVarNest.Spread),
                    Option.None
                )
            )
        );
    }
    
    private static function structOptionalForwardVar(name:String, typeName:String):StructElement
    {
        return StructElement.Var(
            new StructVarElement(
                new VariableName(name),
                primitiveType(typeName),
                new StructVarAttributes(
                    Option.Some(VarRule.Optional),
                    Option.Some(StructVarNest.Forward),
                    Option.None
                )
            )
        );
    }
}
