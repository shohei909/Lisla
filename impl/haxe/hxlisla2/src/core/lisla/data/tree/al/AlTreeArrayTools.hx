package lisla.data.tree.al;
import hxext.ds.Result;
import lisla.data.meta.core.Metadata;
import lisla.data.tree.al.AlTree;

class AlTreeArrayTools 
{
    public static function mapOrError<LeafType, NewLeafType, ErrorType>(
        array:Array<AlTree<LeafType>>,
        func:LeafType->Metadata->Result<NewLeafType, Array<ErrorType>>,
        persevering:Bool
    ):Result<Array<AlTree<NewLeafType>>, Array<ErrorType>> {
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
