package lisla.data.tree.array;

import hxext.ds.Result;
import lisla.data.meta.core.Metadata;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.DataWithRange;
import lisla.data.meta.position.LineIndexes;
import lisla.error.core.LislaError;
import lisla.parse.result.ParseErrorResult;
import lisla.parse.result.ParseResultBase;

class ArrayTreeDocument<LeafType> extends ParseResultBase 
{
    public var data(default, null):Array<ArrayTree<LeafType>>;
    public var metadata(default, null):Metadata;
    
    public function new(
        data:Array<ArrayTree<LeafType>>,
        metadata:Metadata,
        lines:LineIndexes,
        length:CodePointIndex
    ) 
    {
        this.data = data;
        this.metadata = metadata;
        super(lines, length);
    }
    
    public function mapOrError<NewLeafType, ErrorType:LislaError>(
        func:LeafType->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<ArrayTreeDocument<NewLeafType>, ParseErrorResult<ErrorType>>
    {
        return switch (ArrayTreeArrayTools.mapOrError(data, func, persevering)) 
        {
            case Result.Ok(ok):
                Result.Ok(new ArrayTreeDocument(ok, metadata.shallowClone(), lines, length));
                
            case Result.Error(errors):
                Result.Error(new ParseErrorResult(errors, lines, length));
        }
    }
}
