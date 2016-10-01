package litll.idl.project.source;

class ModuleStateTools
{
	public static function isParseStarted(state:ModuleState):Bool
	{
		return switch (state)
		{
			case ModuleState.Loaded(_) | ModuleState.Loading(_): 
				true;
				
			case ModuleState.Unloaded:
				false;
		}
	}
}
