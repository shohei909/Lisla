package arraytree.data.tree.array;
import hxext.ds.Result;
import arraytree.data.meta.core.Tag;
import arraytree.data.tree.array.ArrayTree;

class ArrayTreeArrayTools 
{
    public static function mapOrError<LeafType, NewLeafType, ErrorType>(
        array:Array<ArrayTree<LeafType>>,
        func:LeafType->Tag->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<Array<ArrayTree<NewLeafType>>, Array<ErrorType>> {
        var errors = [];
        var data = [];
        for (element in array) {
            switch (element.mapOrError(func, persevering)) {
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
