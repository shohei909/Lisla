package lisla.idl.std.error;

import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.error.core.ElementaryError;
import lisla.error.core.ErrorName;
import lisla.error.core.InlineError;
import lisla.idl.std.entity.idl.EnumConstructorName;

class EnumConstructorSuffixError 
    implements InlineError
    implements ElementaryError
{
    private var kind:EnumConstructorSuffixErrorKind;
    private var name:EnumConstructorName;
    
    public function new(
        name:EnumConstructorName, 
        kind:EnumConstructorSuffixErrorKind
        // TODO: 
        // range:Option<Range>
    ) 
    {
        this.name = name;
        this.kind = kind;
    }
    
    public function getMessage():String
    {
        return return switch(kind)
        {
            case EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorParameterLength(actual):
                "Inline target type number must be one. but actual " + actual + ".";
                
            case EnumConstructorSuffixErrorKind.InvalidInlineEnumConstructorLabel:
                "Inline target must not be label.";
                
            case EnumConstructorSuffixErrorKind.InlineSuffixForPrimitiveEnumConstructor:
                "Inline is not allowed for primitive enum constructor.";
                
            case EnumConstructorSuffixErrorKind.LoopedInline(typePath):
                "Inline " + typePath.toString() + " is looped.";
                
            case EnumConstructorSuffixErrorKind.TupleSuffixForPrimitiveEnumConstructor:
                "Tuple is not allowed for primitive enum constructor.";
        }
    }
    
    public function getErrorName():ErrorName
    {
        return ErrorName.fromEnum(kind);
    }
    
    public function getOptionRange():Option<Range>
    {
        // FIXME: 
        return Option.None;
    }
    
    public function getInlineError():InlineError
    {
        return this;
    }
    
    public function getElementaryError():ElementaryError
    {
        return this;
    }
}
