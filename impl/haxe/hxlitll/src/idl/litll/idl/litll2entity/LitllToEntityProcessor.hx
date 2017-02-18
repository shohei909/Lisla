package litll.idl.litll2entity;
import hxext.ds.Result;

typedef LitllToEntityProcessor<T> =
{
    public function process(context:LitllToEntityContext):Result<T, LitllToEntityError>;
}
