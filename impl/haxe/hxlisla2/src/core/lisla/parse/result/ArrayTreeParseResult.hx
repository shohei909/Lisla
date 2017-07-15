package lisla.parse.result;

import hxext.ds.Result;
import lisla.data.meta.position.DataWithRange;
import lisla.data.tree.array.ArrayTreeDocument;
import lisla.error.parse.ArrayTreeParseError;
import lisla.parse.result.ArrayTreeParseResult;

typedef ArrayTreeParseResult = Result<ArrayTreeDocument<String>, ParseErrorResult<ArrayTreeParseError>>;
