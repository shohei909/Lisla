package lisla.parse.result;

import hxext.ds.Result;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.tree.array.ArrayTreeBlock;
import lisla.error.core.InlineToBlockErrorWrapper;
import lisla.error.parse.BasicParseError;

typedef ArrayTreeTemplateParseResult = Result<ArrayTreeBlock<TemplateLeaf>, Array<InlineToBlockErrorWrapper<BasicParseError>>>;
