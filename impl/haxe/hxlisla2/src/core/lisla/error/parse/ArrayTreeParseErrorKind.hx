package lisla.error.parse;
import lisla.error.template.TemplateFinalizeError;

enum ArrayTreeParseErrorKind
{
    TemplateFinalize(error:TemplateFinalizeError);
    Basic(parse:BasicParseError);
}
