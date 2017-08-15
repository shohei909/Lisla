package lisla.error.parse;
import lisla.error.template.TemplateFinalizeError;

enum AlTreeParseErrorKind
{
    TemplateFinalize(error:TemplateFinalizeError);
    Basic(parse:BasicParseError);
}
