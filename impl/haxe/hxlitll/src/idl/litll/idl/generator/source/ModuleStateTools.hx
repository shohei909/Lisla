package litll.idl.generator.source;

class ModuleStateTools
{
	public static function isLoadStarted(state:ModuleState):Bool
	{
		return switch (state)
		{
			case ModuleState.Validated(_) | ModuleState.Validating(_) | ModuleState.Loaded(_) | ModuleState.Loading(_) | ModuleState.Empty: 
				true;
				
			case ModuleState.Unloaded:
				false;
		}
	}
    
	public static function isValidationStarted(state:ModuleState):Bool
	{
		return switch (state)
		{
			case ModuleState.Validated(_) | ModuleState.Validating(_) | ModuleState.Empty: 
				true;
				
			case ModuleState.Unloaded | ModuleState.Loaded(_) | ModuleState.Loading(_):
				false;
		}
	}
}
