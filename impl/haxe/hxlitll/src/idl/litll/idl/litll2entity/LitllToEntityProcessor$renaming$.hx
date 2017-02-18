package litll.idl.litll2entity;
import litll.core.ds.Result;

typedef LitllToEntityProcessor<T> =
{
    public function process(context:LitllToEntityContext):Result<T, LitllToEntityError>;
}
