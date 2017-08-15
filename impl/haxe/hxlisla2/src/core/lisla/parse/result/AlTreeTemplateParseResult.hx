package lisla.parse.result;

import hxext.ds.Result;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.tree.al.AlTreeBlock;
import lisla.error.core.InlineToBlockErrorWrapper;
import lisla.error.parse.BasicParseError;

typedef AlTreeTemplateParseResult = Result<AlTreeBlock<TemplateLeaf>, Array<InlineToBlockErrorWrapper<BasicParseError>>>;
