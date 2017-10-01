package lisla.template;
import hxext.ds.Result;
import lisla.data.leaf.template.TemplateLeaf;
import lisla.data.meta.core.Metadata;
import lisla.error.template.TemplateFinalizeError;
import lisla.error.template.TemplateFinalizeErrorKind;

class TemplateFinalizer 
{
    public static function finalize(
        leaf:TemplateLeaf, 
        metadata:Metadata
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
                            metadata.position
                        )
                    ]
                );
        }
    }
}
