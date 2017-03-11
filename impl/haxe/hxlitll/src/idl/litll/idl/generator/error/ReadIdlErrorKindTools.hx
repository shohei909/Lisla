package litll.idl.generator.error;
import hxext.ds.Maybe;
import litll.core.LitllTools;
import litll.core.error.IInlineErrorSummary;
import litll.core.error.InlineErrorSummary;
import litll.core.tag.Tag;
import litll.idl.litlltext2entity.error.LitllTextToEntityErrorKindTools;

class ReadIdlErrorKindTools 
{
    public static function getSummary(errorKind:ReadIdlErrorKind):InlineErrorSummary<ReadIdlErrorKind>
	{
        inline function summary(tag:Maybe<Tag>, message:String):InlineErrorSummary<ReadIdlErrorKind>
        {
            return new InlineErrorSummary(
                tag.getRange(), 
                message,
                errorKind
            );
        }
        
		return switch (errorKind)
		{
            case ReadIdlErrorKind.LibraryNotFoundInLibraryConfig(configTag, referencerName, referenceeName):
                summary(configTag.upCast(), "Library " + referenceeName + " is referenced in " + referencerName + ", but it is not found in library config file");
            
            case ReadIdlErrorKind.LibraryNotFound(name):
                summary(name.tag.upCast(), "Library " + name.data + " is not found");
            
            case ReadIdlErrorKind.LibraryVersionNotFound(name, version):
                summary(version.tag.upCast(), "Library " + name + " version " + version.data + " is not found");
                
			case ReadIdlErrorKind.LitllTextToEntity(error):
				LitllTextToEntityErrorKindTools.getSummary(error).replaceKind(errorKind);
				
			case ReadIdlErrorKind.ModuleDuplicated(module, existingPath):
                new InlineErrorSummary(
                    Maybe.none(), 
                    "Module " + module.toString() + " is duplicated with " + existingPath.toString(),
                    errorKind
                );
				
			case ReadIdlErrorKind.TypeNameDuplicated(typePath):
                summary(typePath.tag.upCast(), "Type " + typePath.toString() + " is duplicated");
				
			case ReadIdlErrorKind.TypeParameterNameDuplicated(name):
				summary(name.tag.upCast(), "Type parameter name " + name.toString() + " is duplicated");
				
			case ReadIdlErrorKind.InvalidPackage(expected, actual):
				summary(actual.tag.upCast(), "Package name " + expected.toString() + " is expected but " + actual.toString());
				
			case ReadIdlErrorKind.TypeNotFound(path):
				summary(path.tag.upCast(), "Type " + path.toString() + " is not found");
				
			case ReadIdlErrorKind.ModuleNotFound(path):
				summary(path.tag.upCast(), "Module " + path.toString() + " is not found");
                
            case ReadIdlErrorKind.InvalidTypeDependenceDescription(litll):
                summary(LitllTools.getTag(litll).upCast(), "Invalid " + LitllTools.toString(litll) + " is loop");
                
            case ReadIdlErrorKind.Validation(error):
                IdlValidationErrorKindTools.getSummary(error).replaceKind(errorKind);
		}
	}
}
