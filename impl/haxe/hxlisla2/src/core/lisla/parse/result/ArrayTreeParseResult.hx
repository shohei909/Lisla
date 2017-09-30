package lisla.parse.result;

import hxext.ds.Result;
import lisla.data.tree.array.ArrayTreeBlock;
import lisla.error.parse.ArrayTreeParseError;
import lisla.parse.result.ArrayTreeParseResult;

typedef ArrayTreeParseResult = Result<ArrayTreeBlock<String>, Array<ArrayTreeParseError>>;
