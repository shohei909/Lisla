package lisla.error.core;
import haxe.ds.Option;
import lisla.data.meta.position.Position;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.error.parse.ArrayTreeParseError;
import lisla.project.LocalPath;
import lisla.project.ProjectRootDirectory;

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
        return getMessage() + "(" + getName() + ")";
    }
    
    public function convert<T:IErrorDetailHolder>(newDetailHolder:T):Error<T>
    {
        return new Error(
            newDetailHolder,
            position
        );
    }
}
