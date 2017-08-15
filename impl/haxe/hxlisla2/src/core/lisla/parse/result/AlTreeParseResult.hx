package lisla.parse.result;

import hxext.ds.Result;
import lisla.data.tree.al.AlTreeBlock;
import lisla.error.parse.AlTreeParseError;
import lisla.parse.result.AlTreeParseResult;

typedef AlTreeParseResult = Result<AlTreeBlock<String>, Array<AlTreeParseError>>;
