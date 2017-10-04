package arraytree.parse.result;

import hxext.ds.Result;
import arraytree.data.tree.array.ArrayTreeDocument;
import arraytree.error.core.Error;
import arraytree.error.parse.ArrayTreeParseError;
import arraytree.parse.result.ArrayTreeParseResult;

typedef ArrayTreeParseResult = Result<ArrayTreeDocument<String>, Array<ArrayTreeParseError>>;
