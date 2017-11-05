package lisla.idl.error;
import hxext.ds.Maybe;
import lisla.data.meta.position.Position;
import lisla.error.core.Error;
import lisla.error.core.ErrorName;
import lisla.error.core.IErrorDetail;
import lisla.idl.error.IdlModuleErrorKind;

class IdlModuleError extends Error<IdlModuleErrorDetail>
{
    public function new(kind:IdlModuleErrorKind, position:Maybe<Position>) 
    {
        super(
            new IdlModuleErrorDetail(kind),
            position
        );
    }   
}

class IdlModuleErrorDetail implements IErrorDetail
{
    public var kind(default, null):IdlModuleErrorKind;   
    public inline function new (kind:IdlModuleErrorKind)
    {
        this.kind = kind;
    }
    
    public function getMessage():String 
    {
        return switch (kind)
        {
			case IdlModuleErrorKind.ImportDuplicated(typeName, anotherPath):
				'TypeName $typeName is duplicated with $anotherPath';
				
			case IdlModuleErrorKind.ImportMustBeHead:
				'Import can not appear after a type declaration';
                
                
			case IdlModuleErrorKind.TooManyTypeArgument:
				'Too many type argument';
                
			case IdlModuleErrorKind.NotEnoughTypeArgument:
				'Not enough type argument';
				
			case IdlModuleErrorKind.UnexpectedTypeArgument:
				'Unexpected type argument';
                
			case IdlModuleErrorKind.TypeArgumentRequired:
				'type argument required';
                
            case IdlModuleErrorKind.ValueRequired:
                'Value required';
                
            case IdlModuleErrorKind.ValueMustBeString:
                'Value must be string';
        }
    }
    
    public function getErrorName():ErrorName 
    {
        return ErrorName.fromEnum(kind);
    }
    
    public function getDetail():IErrorDetail
    {
        return this;
    }
}
