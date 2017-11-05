package lisla.idl.code.library;
import lisla.data.tree.array.ArrayTree;
import lisla.type.lisla.type.VariableName;

enum CodeValue
{
    Reference(reference:VariableName);
    Value(value:ArrayTree<String>);
}
