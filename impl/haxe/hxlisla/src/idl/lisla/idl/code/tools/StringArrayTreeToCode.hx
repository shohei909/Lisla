package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.data.tree.array.ArrayTree;
import lisla.data.tree.array.StringArrayTree;
import lisla.idl.code.library.CodeTypeReference;
import lisla.idl.code.library.CodeValue;
import lisla.idl.error.IdlModuleErrorKind;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.GenericTypeReference;
import lisla.type.lisla.type.TypePath;
import lisla.type.lisla.type.TypeReference;
import lisla.type.lisla.type.VariableName;

class StringArrayTreeToCode 
{
    public static function toTypeReference(
        value:WithTag<StringArrayTree>,
        context:ModuleToCodeContext
    ):WithTag<CodeTypeReference>
    {
        var reference = value.convert(
            switch (value.data)
            {
                case ArrayTree.Leaf(string):
                    TypeReference.Primitive(new TypePath(string));
                    
                case ArrayTree.Arr(array):
                    var path = if (array.length == 0)
                    {
                        context.addError(IdlModuleErrorKind.ValueRequired, value.tag);
                        new WithTag(new TypePath(""));
                    }
                    else
                    {
                        var first = array[0];
                        switch (first.data)
                        {
                            case ArrayTree.Arr(_):
                                context.addError(IdlModuleErrorKind.ValueMustBeString, first.tag);
                                new WithTag(new TypePath(""), first.tag);
                                
                            case ArrayTree.Leaf(string):
                                new WithTag(new TypePath(string), first.tag);
                        }
                    }
                    
                    TypeReference.Generic(
                        new GenericTypeReference(
                            path,
                            [for (element in array.slice(1)) element]
                        )
                    );
            }
        );
        
        return TypeReferenceToCode.toCode(reference, context);
    }
    
    public static function toValue(
        value:WithTag<StringArrayTree>,
        context:ModuleToCodeContext
    ):WithTag<CodeValue>
    {
        return value.convert(
            switch (value.data)
            {
                case ArrayTree.Leaf(string):
                    if (StringTools.startsWith(string, "$$"))
                    {
                        CodeValue.Value(
                            ArrayTree.Leaf(string.substr(2))
                        );
                    }
                    else if (StringTools.startsWith(string, "$"))
                    {
                        
                        CodeValue.Reference(new VariableName(string));
                    }
                    else
                    {
                        CodeValue.Value(value.data);
                    }
                    
                case ArrayTree.Arr(array):
                    CodeValue.Value(value.data);
            }
        );
    }
}
