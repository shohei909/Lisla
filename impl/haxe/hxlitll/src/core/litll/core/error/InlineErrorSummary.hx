package lisla.core.error;

import haxe.EnumTools.EnumValueTools;
import hxext.ds.Maybe;
import lisla.core.error.IInlineErrorSummary;
import lisla.core.ds.SourceRange;

class InlineErrorSummary<ErrorKind:EnumValue> implements IInlineErrorSummary
{
    public var range:Maybe<SourceRange>;
    public var message:String;
    public var kind:ErrorKind;

    public function new(
        range:Maybe<SourceRange>,
        message:String,
        kind:ErrorKind
    ) 
    {
        this.range = range;
        this.message = message;
        this.kind = kind;
    }
    
    public function withFile(file:String):FileErrorSummary<ErrorKind>
    {
        return new FileErrorSummary(
            file,
            range,
            message,
            kind
        );
    }
    
    public inline function map<DestErrorKind:EnumValue>(func:ErrorKind->DestErrorKind):InlineErrorSummary<DestErrorKind>
    {
        return replaceKind(func(kind));
    }
    
    public inline function replaceKind<DestErrorKind:EnumValue>(destKind:DestErrorKind):InlineErrorSummary<DestErrorKind>
    {
        return new InlineErrorSummary(
            range, 
            message,
            destKind
        );
    }
    
    public function toString():String
    {
        var rangeString = range.map(function (r) return r.toString() + ": ").getOrElse("");
        var kindString = " (kind: " + Type.getEnumName(Type.getEnum(kind)) + "." + EnumValueTools.getName(kind) + ")";
        return rangeString + message + kindString;
    }
}
