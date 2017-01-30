package litll.idl.delitllfy;
import litll.core.ds.Result;

typedef DelitllfyProcessor<T> =
{
    public function process(context:DelitllfyContext):Result<T, DelitllfyError>;
}
