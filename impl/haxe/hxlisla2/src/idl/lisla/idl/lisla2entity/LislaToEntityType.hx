package arraytree.idl.arraytree2entity;
import hxext.ds.Result;
import arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError;
typedef ArrayTreeToEntityType<T> =
{
    public function process(
        context:ArrayTreeToEntityContext
    ):Result<T, Array<ArrayTreeToEntityError>>; // FIXME: Array<DataWithRange<ArrayTreeToEntityError>>
}
