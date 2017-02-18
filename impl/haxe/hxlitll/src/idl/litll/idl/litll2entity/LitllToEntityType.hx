package litll.idl.litll2entity;
import hxext.ds.Result;
import litll.idl.litll2entity.error.LitllToEntityError;

typedef LitllToEntityType<T> =
{
    public function process(context:LitllToEntityContext):Result<T, LitllToEntityError>;
}
