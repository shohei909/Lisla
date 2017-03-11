package litll.idl.generator.error;
import hxext.ds.Maybe;
import litll.core.LitllTools;
import litll.core.error.IInlineErrorSummary;
import litll.core.error.InlineErrorSummary;
import litll.core.tag.Tag;
import litll.idl.litlltext2entity.error.LitllTextToEntityErrorKindTools;

class LoadIdlErrorKindTools 
{
    public static function getSummary(errorKind:LoadIdlErrorKind):InlineErrorSummary<LoadIdlErrorKind>
	{
        inline function summary(tag:Maybe<Tag>, message:String):InlineErrorSummary<LoadIdlErrorKind>
        {
            return new InlineErrorSummary(
                tag.getRange(), 
                message,
                errorKind
            );
        }
        
		return switch (errorKind)
		{
            case LoadIdlErrorKind.LibraryNotFoundInLibraryConfig(configTag, referencerName, referenceeName):
                summary(configTag.upCast(), "Library " + referenceeName + " is referenced in " + referencerName + ", but it is not found in library config file");
            
            case LoadIdlErrorKind.LibraryNotFound(name):
                summary(name.tag.upCast(), "Library " + name.data + " is not found");
            
            case LoadIdlErrorKind.LibraryVersionNotFound(name, version):
                summary(version.tag.upCast(), "Library " + name + " version " + version.data + " is not found");
                
			case LoadIdlErrorKind.LitllTextToEntity(error):
				LitllTextToEntityErrorKindTools.getSummary(error).replaceKind(errorKind);
				
			case LoadIdlErrorKind.ModuleDuplicated(module, existingPath):
                new InlineErrorSummary(
                    Maybe.none(), 
                    "Module " + module.toString() + " is duplicated with " + existingPath.toString(),
                    errorKind
                );
				
			case LoadIdlErrorKind.TypeNameDuplicated(typePath):
                summary(typePath.tag.upCast(), "Type " + typePath.toString() + " is duplicated");
				
			case LoadIdlErrorKind.TypeParameterNameDuplicated(name):
				summary(name.tag.upCast(), "Type parameter name " + name.toString() + " is duplicated");
				
			case LoadIdlErrorKind.InvalidPackage(expected, actual):
				summary(actual.tag.upCast(), "Package name " + expected.toString() + " is expected but " + actual.toString());
				
			case LoadIdlErrorKind.TypeNotFound(path):
				summary(path.tag.upCast(), "Type " + path.toString() + " is not found");
				
			case LoadIdlErrorKind.ModuleNotFound(path):
				summary(path.tag.upCast(), "Module " + path.toString() + " is not found");
                
            case LoadIdlErrorKind.InvalidTypeDependenceDescription(litll):
                summary(LitllTools.getTag(litll).upCast(), "Invalid " + LitllTools.toString(litll) + " is loop");
                
            case LoadIdlErrorKind.Validation(error):
                IdlValidationErrorKindTools.getSummary(error).replaceKind(errorKind);
		}
	}
}
