package lisla.idl.generator.io;

interface IoProvider 
{
	public function printErrorLine(message:String):Void;
	public function printInfoLine(message:String):Void;
	public function printDebugLine(message:String):Void;
}
