package litll.idl.generator.io;

#if sys
/**
 * Standard IO implemention of IoProvider.
 */
class StandardIoProvider implements IoProvider
{
	public var outputsError:Bool = true;
	public var outputsInfo:Bool = true;
	public var outputsDebug:Bool = true;
	
	public function new () 
	{
	}
	
	public function printErrorLine(message:String):Void
	{
		Sys.stdout().writeString("Error: " + message + "\n");
	}
	
	public function printInfoLine(message:String):Void
	{
		Sys.stdout().writeString("Info: " + message + "\n");
	}
	
	public function printDebugLine(message:String):Void
	{
		Sys.stdout().writeString("Debug: " + message + "\n");
	}
}
#end