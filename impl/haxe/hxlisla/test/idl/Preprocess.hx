import haxe.io.Path;
import hxext.ds.Result;
import lisla.data.tree.array.ArrayTree;
import lisla.type.core.IdlAny;
import lisla.type.lisla.type.Declaration;
import lisla.type.lisla.type.GenericTypeDeclaration;
import lisla.type.lisla.type.GenericTypeReference;
import lisla.type.lisla.type.Idl;
import lisla.type.lisla.type.NewtypeDeclaration;
import lisla.type.lisla.type.TypeArgument;
import lisla.type.lisla.type.TypeDeclaration;
import lisla.type.lisla.type.TypeName;
import lisla.type.lisla.type.TypeParameterDeclaration;
import lisla.type.lisla.type.TypePath;
import lisla.type.lisla.type.TypeReference;
import lisla.type.lisla.type.TypeTypeParameterDeclaration;
import sys.FileSystem;
using hxext.ds.ResultTools;

class Preprocess 
{
    public static function main():Void
    {
        new Idl(
            [
                Declaration.Newtype(
                    new NewtypeDeclaration(
                        TypeDeclaration.Primitive(
                            new TypeName("Idl")
                        ),
                        TypeReference.Generic(
                            new GenericTypeReference(
                                new TypePath("Array"), 
                                [
                                    new TypeArgument(
                                        IdlAny.AArrayTree(
                                            ArrayTree.fromString("Declaration")
                                        )
                                    ),
                                ]
                            )
                        )
                    )
                ),
            ]
        );
    }
}
