package litll.idl.generator.output.delitll.path;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.delitll.path.HaxeDelitllfierTypePath;
import litll.idl.generator.output.DataTypeInfomation;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypePath;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.DelitllfierOutputConfig;

class HaxeDelitllfierTypePathPair
{
    public var typeInfo(default, null):DataTypeInfomation;
	public var delitllfierPath(default, null):HaxeDelitllfierTypePath;
	
	public function new(typeInfo:DataTypeInfomation, delitllfierPath:HaxeDelitllfierTypePath) 
	{
		this.typeInfo = typeInfo;
        this.delitllfierPath = delitllfierPath;
	}
}
