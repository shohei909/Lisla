package litll.idl.litllToBackend;
import litll.core.ds.Result;

typedef LitllToBackendProcessor<T> =
{
    public function process(context:LitllToBackendContext):Result<T, LitllToBackendError>;
}
