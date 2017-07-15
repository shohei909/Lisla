package lisla.parse.result;
import lisla.data.meta.position.CodePointIndex;
import lisla.data.meta.position.DataWithRange;
import lisla.data.meta.position.LineIndexes;
import lisla.error.core.LislaError;

class ParseErrorResult<ErrorType:LislaError> extends ParseResultBase 
{
    public var errors(default, null):Array<DataWithRange<ErrorType>>;

    public function new(
        errors:Array<DataWithRange<ErrorType>>,
        lines:LineIndexes,
        length:CodePointIndex
    ) {
        super(lines, length);
        this.errors = errors;
    }

    public function map<NewErrorType:LislaError>(func:ErrorType->NewErrorType):ParseErrorResult<NewErrorType> {
        return new ParseErrorResult(
            [for (error in errors) error.map(func)],
            lines,
            length
        );
    }
}
