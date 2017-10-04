package arraytree.error.parse;
import arraytree.error.parse.BasicParseError.BasicParseErrorDetail;
import arraytree.error.template.TemplateFinalizeError;

enum ArrayTreeParseErrorKind
{
    TemplateFinalize(error:TemplateFinalizeErrorDetail);
    Basic(parse:BasicParseErrorDetail);
}
