package lisla.idl.code.library;
import lisla.idl.code.library.CodeConstElement;
import lisla.type.lisla.type.ConstElement;
import lisla.type.lisla.type.StructVarElement;

enum CodeStructElement 
{
    Const(value:CodeConstElement);
    Var(value:CodeStructVarElement);    
}
