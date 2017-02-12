package litll.idl.litll2backend;
import litll.core.ds.Result;

typedef LitllToBackendProcessor<T> =
{
    public function process(context:LitllToBackendContext):Result<T, LitllToBackendError>;
}
