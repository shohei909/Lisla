package lisla.error.parse;
import lisla.error.template.TemplateFinalizeErrorKind;
import lisla.error.parse.BasicParseErrorKind;

enum ArrayTreeParseErrorKind
{
    TemplateFinalize(error:TemplateFinalizeErrorKind);
    Basic(parse:BasicParseErrorKind);
}
