package lisla.core.error;
import haxe.EnumTools.EnumValueTools;
import haxe.io.Path;
import hxext.ds.Maybe;
import lisla.core.ds.SourceRange;

class FileErrorSummary<ErrorKind:EnumValue> implements IFileErrorSummary
{
    public var file:String;
    public var range:Maybe<SourceRange>;
    public var message:String;
    public var kind:ErrorKind;
    
    public function new(
        file:String, 
        range:Maybe<SourceRange>,
        message:String,
        kind:ErrorKind
    )
    {
        this.kind = kind;
        this.file = file;
        this.range = range;
        this.message = message;
        this.kind = kind;
    }
    
    public inline function map<DestErrorKind:EnumValue>(func:ErrorKind->DestErrorKind):FileErrorSummary<DestErrorKind>
    {
        return replaceKind(func(kind));
    }
    
    public inline function replaceKind<DestErrorKind:EnumValue>(destKind:DestErrorKind):FileErrorSummary<DestErrorKind>
    {
        return new FileErrorSummary(
            file,
            range, 
            message,
            destKind
        );
    }
    
    public function toString():String
    {
        var fileString = Path.normalize(file) + ": ";
        var rangeString = range.map(function (r) return r.toString() + ": ").getOrElse("");
        var kindString = " (kind: " + Type.getEnumName(Type.getEnum(kind)) + "." + EnumValueTools.getName(kind) + ")";
        return fileString + rangeString + message + kindString; 
    }
}
