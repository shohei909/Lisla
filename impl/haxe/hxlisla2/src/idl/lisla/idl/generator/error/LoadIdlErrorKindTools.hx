package lisla.idl.generator.error;
import hxext.ds.Maybe;
import lisla.core.LislaTools;
import lisla.core.error.IInlineErrorSummary;
import lisla.error.core.InlineErrorSummary;
import lisla.data.meta.core.Metadata;
import lisla.idl.lislatext2entity.error.LislaTextToEntityError;

class LoadIdlErrorKindTools 
{
    public static function getSummary(errorKind:LoadIdlErrorKind):InlineErrorSummary<LoadIdlErrorKind>
	{
        inline function summary(metadata:Metadata, message:String):InlineErrorSummary<LoadIdlErrorKind>
        {
            return new InlineErrorSummary(
                metadata.getRange(), 
                message,
                errorKind
            );
        }
        
		return switch (errorKind)
		{
            case LoadIdlErrorKind.LibraryNotFoundInLibraryConfig(configTag, referencerName, referenceeName):
                summary(configTag.upCast(), "Library '" + referenceeName + "' is referenced in '" + referencerName + "', but it is not found in library config file");
            
            case LoadIdlErrorKind.LibraryNotFound(name):
                summary(name.metadata.upCast(), "Library '" + name.data + "' is not found");
            
            case LoadIdlErrorKind.LibraryVersionNotFound(name, version):
                summary(version.metadata.upCast(), "Library '" + name + "' version '" + version.data + "' is not found");
                
			case LoadIdlErrorKind.LislaTextToEntity(error):
				LislaTextToEntityError.getSummary(error).replaceKind(errorKind);
				
			case LoadIdlErrorKind.ModuleDuplicated(module, existingPath):
                new InlineErrorSummary(
                    Maybe.none(), 
                    "Module '" + module.toString() + "' is duplicated with " + existingPath.toString(),
                    errorKind
                );
				
			case LoadIdlErrorKind.TypeNameDuplicated(typePath):
                summary(typePath.metadata.upCast(), "Type '" + typePath.toString() + "' is duplicated");
				
			case LoadIdlErrorKind.TypeParameterNameDuplicated(name):
				summary(name.metadata.upCast(), "Type parameter name '" + name.toString() + "' is duplicated");
				
			case LoadIdlErrorKind.InvalidPackage(expected, actual):
				summary(actual.metadata.upCast(), "Package name '" + expected.toString() + "' is expected but '" + actual.toString() + "'");
				
			case LoadIdlErrorKind.TypeNotFound(path):
				summary(path.metadata.upCast(), "Type " + path.toString() + " is not found");
				
			case LoadIdlErrorKind.ModuleNotFound(path):
				summary(path.metadata.upCast(), "Module " + path.toString() + " is not found");
                
            case LoadIdlErrorKind.InvalidTypeDependenceDescription(lisla):
                summary(LislaTools.getTag(lisla).upCast(), "Invalid '" + LislaTools.toString(lisla) + "' is loop");
                
            case LoadIdlErrorKind.Validation(error):
                IdlValidationErrorKindTools.getSummary(error).replaceKind(errorKind);
		}
	}
}