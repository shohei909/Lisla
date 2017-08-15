package lisla.idl.generator.output.lisla2entity.path;
import lisla.idl.generator.output.entity.EntityHaxeTypePath;
import lisla.idl.generator.output.lisla2entity.path.HaxeLislaToEntityTypePath;
import lisla.idl.generator.output.EntityTypeInfomation;
import lisla.idl.generator.source.validate.ValidType;
import lisla.idl.std.entity.idl.TypePath;
import lisla.idl.generator.data.EntityOutputConfig;
import lisla.idl.generator.data.LislaToEntityOutputConfig;

class HaxeLislaToEntityTypePathPair
{
    public var typeInfo(default, null):EntityTypeInfomation;
	public var lislaToEntityPath(default, null):HaxeLislaToEntityTypePath;
	
	public function new(typeInfo:EntityTypeInfomation, lislaToEntityPath:HaxeLislaToEntityTypePath) 
	{
		this.typeInfo = typeInfo;
        this.lislaToEntityPath = lislaToEntityPath;
	}
}
