package litll.idl.generator.output.litll2entity.path;
import litll.idl.generator.output.entity.EntityHaxeTypePath;
import litll.idl.generator.output.litll2entity.path.HaxeLitllToEntityTypePath;
import litll.idl.generator.output.EntityTypeInfomation;
import litll.idl.generator.source.validate.ValidType;
import litll.idl.std.data.idl.TypePath;
import litll.idl.generator.data.EntityOutputConfig;
import litll.idl.generator.data.LitllToEntityOutputConfig;

class HaxeLitllToEntityTypePathPair
{
    public var typeInfo(default, null):EntityTypeInfomation;
	public var litllToEntityPath(default, null):HaxeLitllToEntityTypePath;
	
	public function new(typeInfo:EntityTypeInfomation, litllToEntityPath:HaxeLitllToEntityTypePath) 
	{
		this.typeInfo = typeInfo;
        this.litllToEntityPath = litllToEntityPath;
	}
}
