package lisla.parse.result;

import hxext.ds.Result;
import lisla.data.tree.array.ArrayTreeDocument;
import lisla.error.core.Error;
import lisla.error.parse.ArrayTreeParseError;
import lisla.parse.result.ArrayTreeParseResult;

typedef ArrayTreeParseResult = Result<ArrayTreeDocument<String>, Array<ArrayTreeParseError>>;
