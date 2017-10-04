package arraytree.parse.result;

import hxext.ds.Result;
import arraytree.data.leaf.template.TemplateLeaf;
import arraytree.data.tree.array.ArrayTreeDocument;
import arraytree.error.parse.BasicParseError;

typedef ArrayTreeTemplateParseResult = Result<ArrayTreeDocument<TemplateLeaf>, Array<BasicParseError>>;
