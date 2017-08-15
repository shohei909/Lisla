package lisla.idl.library;
import lisla.idl.library.ModuleState;

class ModuleStateTools
{
	public static function isResolutionStarted(state:ModuleState):Bool
	{
		return switch (state)
		{
			case ModuleState.Validated(_) | ModuleState.Validating(_) | ModuleState.Resolved(_) | ModuleState.Resolving(_) | ModuleState.Empty: 
				true;
				
			case ModuleState.None:
				false;
		}
	}
    
	public static function isValidationStarted(state:ModuleState):Bool
	{
		return switch (state)
		{
			case ModuleState.Validated(_) | ModuleState.Validating(_) | ModuleState.Empty: 
				true;
				
			case ModuleState.None | ModuleState.Resolved(_) | ModuleState.Resolving(_):
				false;
		}
	}
}
