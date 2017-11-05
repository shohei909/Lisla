package lisla.idl.code.tools;
import lisla.data.meta.core.WithTag;
import lisla.idl.code.library.CodeTypeReference;
import lisla.idl.code.read.TypeArgumentReader;
import lisla.idl.error.IdlModuleErrorKind;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TypeNameDeclaration;
import lisla.type.lisla.type.TypeReference;

class TypeReferenceToCode
{
    public static function toCode(
        value:WithTag<TypeReference>,
        context:ModuleToCodeContext
    ):WithTag<CodeTypeReference>
    {
        var codePath = TypePathToCode.toCode(
            value.convert(
                switch (value.data)
                {
                    case TypeReference.Primitive(_value):
                        _value;
                        
                    case TypeReference.Generic(_value):
                        _value.name.data;
                }
            ),
            context
        );
        
        var declaration = context.resolveTypeNameDeclaration(codePath.data.idlPath.data);
        
        return value.convert(
            switch [declaration, value.data]
            {
                case [TypeNameDeclaration.Primitive(_), TypeReference.Primitive(_)]:
                    new CodeTypeReference(codePath, []); 
                    
                case [TypeNameDeclaration.Generic(declaration), TypeReference.Generic(reference)]:
                    var reader = new TypeArgumentReader(
                        reference.arguments, 
                        value.tag,
                        context
                    );
                    new CodeTypeReference(
                        codePath,
                        [
                            for (parameter in declaration.parameters)
                            {
                                reader.read(parameter.data);
                            }
                        ]
                    );
                    
                case [TypeNameDeclaration.Generic(_), TypeReference.Primitive(_)]:
                    context.addError(
                        IdlModuleErrorKind.TypeArgumentRequired, 
                        value.tag
                    );
                    new CodeTypeReference(codePath, []); 
                    
                case [TypeNameDeclaration.Primitive(_), TypeReference.Generic(_)]:
                    context.addError(
                        IdlModuleErrorKind.UnexpectedTypeArgument, 
                        value.tag
                    );
                    new CodeTypeReference(codePath, []); 
            }
        );
    }
}
