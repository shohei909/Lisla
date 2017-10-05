package lisla.error.parse;
import lisla.error.parse.BasicParseError.BasicParseErrorDetail;
import lisla.error.template.TemplateFinalizeError;

enum ArrayTreeParseErrorKind
{
    TemplateFinalize(error:TemplateFinalizeErrorDetail);
    Basic(parse:BasicParseErrorDetail);
}
