package lisla.idl.error;
import lisla.type.lisla.type.ImportDeclaration;
import lisla.type.lisla.type.TypeName;
import lisla.type.lisla.type.TypePath;

enum IdlModuleErrorKind
{
    ImportDuplicated(name:TypeName, anotherPath:TypePath);
    ImportMustBeHead;
    
    TypeArgumentRequired;
    UnexpectedTypeArgument;
    TooManyTypeArgument;
    NotEnoughTypeArgument;
    
    ValueRequired;
    ValueMustBeString;
}
