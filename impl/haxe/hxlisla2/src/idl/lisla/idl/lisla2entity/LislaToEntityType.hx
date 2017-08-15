package lisla.idl.lisla2entity;
import hxext.ds.Result;
import lisla.idl.lisla2entity.error.LislaToEntityError;
typedef LislaToEntityType<T> =
{
    public function process(
        context:LislaToEntityContext
    ):Result<T, Array<LislaToEntityError>>; // FIXME: Array<DataWithRange<LislaToEntityError>>
}
