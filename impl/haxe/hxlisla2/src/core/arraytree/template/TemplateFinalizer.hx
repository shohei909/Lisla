package arraytree.template;
import hxext.ds.Result;
import arraytree.data.leaf.template.TemplateLeaf;
import arraytree.data.meta.core.Tag;
import arraytree.error.template.TemplateFinalizeError;
import arraytree.error.template.TemplateFinalizeErrorKind;

class TemplateFinalizer 
{
    public static function finalize(
        leaf:TemplateLeaf, 
        tag:Tag
    ):Result<String, Array<TemplateFinalizeError>>
    {
        return switch (leaf)
        {
            case TemplateLeaf.Str(string):
                Result.Ok(string);
                
            case TemplateLeaf.Placeholder(placeholder):
                Result.Error(
                    [
                        new TemplateFinalizeError(
                            TemplateFinalizeErrorKind.UnbindedPlaceholderExists(placeholder), 
                            tag.position
                        )
                    ]
                );
        }
    }
}
