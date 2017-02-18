package litll.idl.generator.output.delitll.path;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.delitll.path.HaxeLitllToEntityTypePath;
import litll.idl.generator.output.DataTypeInfomation;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypePath;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;

class HaxeLitllToEntityTypePathPair
{
    public var typeInfo(default, null):DataTypeInfomation;
	public var litllToEntityPath(default, null):HaxeLitllToEntityTypePath;
	
	public function new(typeInfo:DataTypeInfomation, litllToEntityPath:HaxeLitllToEntityTypePath) 
	{
		this.typeInfo = typeInfo;
        this.litllToEntityPath = litllToEntityPath;
	}
}
