package litll.idl.generator.output.delitll.path;
import litll.idl.generator.output.data.HaxeDataTypePath;
import litll.idl.generator.output.delitll.path.HaxeLitllToBackendTypePath;
import litll.idl.generator.output.DataTypeInfomation;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypePath;
import litll.idl.generator.data.DataOutputConfig;
import litll.idl.generator.data.LitllToBackendOutputConfig;

class HaxeLitllToBackendTypePathPair
{
    public var typeInfo(default, null):DataTypeInfomation;
	public var litllToBackendPath(default, null):HaxeLitllToBackendTypePath;
	
	public function new(typeInfo:DataTypeInfomation, litllToBackendPath:HaxeLitllToBackendTypePath) 
	{
		this.typeInfo = typeInfo;
        this.litllToBackendPath = litllToBackendPath;
	}
}
