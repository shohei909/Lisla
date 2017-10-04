package arraytree.error.core;
import haxe.ds.Option;
import arraytree.data.meta.position.Position;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceMap;
import arraytree.error.parse.ArrayTreeParseError;
import arraytree.project.LocalPath;
import arraytree.project.ProjectRootDirectory;

class Error<ErrorDetail:IErrorDetailHolder>
{
    public var detailHolder(default, null):ErrorDetail;
    public var position(default, null):Position;
    
    public function new(
        detailHolder:ErrorDetail,
        position:Position
    )
    {
        this.position = position;
        this.detailHolder = detailHolder;
    }

    public function getMessage():String
    {
        return detailHolder.getDetail().getMessage();
    }
    
    public function getName():ErrorName
    {
        return detailHolder.getDetail().getErrorName();
    }
    
    public function toString():String
    {
        return position.toString() + ": " + getMessage() + "(" + getName() + ")";
    }
    
    public function convert<T:IErrorDetailHolder>(newDetailHolder:T):Error<T>
    {
        return new Error(
            newDetailHolder,
            position
        );
    }
}
