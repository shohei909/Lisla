package lisla.data.tree.array;
import hxext.ds.Result;
import lisla.data.meta.core.MaybeTag;
using lisla.data.tree.array.ArrayTreeArrayTools;
using lisla.data.tree.array.ArrayTreeTools;

class ArrayTreeArrayTools 
{
    public static function mapOrError<LeafType, NewLeafType, ErrorType>(
        array:ArrayTreeArray<LeafType>,
        func:LeafType->MaybeTag->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<ArrayTreeArray<NewLeafType>, Array<ErrorType>> {
        var data:ArrayTreeArray<NewLeafType> = [];
        var errors = [];
        for (element in array)
        {
            switch (
                ArrayTreeTools.mapOrError(
                    element,
                    func, 
                    persevering
                )
            ) 
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
