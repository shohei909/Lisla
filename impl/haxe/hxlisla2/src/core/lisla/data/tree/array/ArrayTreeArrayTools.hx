package lisla.data.tree.array;
import hxext.ds.Result;
import lisla.data.meta.position.DataWithRange;

class ArrayTreeArrayTools 
{
    public static function mapOrError<LeafType, NewLeafType, ErrorType>(
        array:Array<ArrayTree<LeafType>>,
        func:LeafType->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<Array<ArrayTree<NewLeafType>>, Array<DataWithRange<ErrorType>>>
    {
        var errors = [];
        var data = [];
        for (element in array)
        {
            switch (element.mapOrError(func, persevering))
            {
                case Result.Ok(ok):
                    data.push(ok);
                    
                case Result.Error(_errors):
                    for (error in _errors) { errors.push(error); }
                    if (!persevering) { break; }
            }
        }
        
        return if (errors.length == 0)
        {
            Result.Ok(data);
        }
        else
        {
            Result.Error(errors);
        }
    }
    
}