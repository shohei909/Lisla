package lisla.parse.result;

import hxext.ds.Result;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.position.DataWithRange;
import lisla.data.tree.array.ArrayTreeDocument;
import lisla.error.parse.BasicParseError;

typedef ArrayTreeTemplateParseResult = Result<ArrayTreeDocument<TemplateLeaf>, ParseErrorResult<BasicParseError>>;