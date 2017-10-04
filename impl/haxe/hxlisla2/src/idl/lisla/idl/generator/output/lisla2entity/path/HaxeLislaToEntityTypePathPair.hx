package arraytree.idl.generator.output.arraytree2entity.path;
import arraytree.idl.generator.output.entity.EntityHaxeTypePath;
import arraytree.idl.generator.output.arraytree2entity.path.HaxeArrayTreeToEntityTypePath;
import arraytree.idl.generator.output.EntityTypeInfomation;
import arraytree.idl.generator.source.validate.ValidType;
import arraytree.idl.std.entity.idl.TypePath;
import arraytree.idl.generator.data.EntityOutputConfig;
import arraytree.idl.generator.data.ArrayTreeToEntityOutputConfig;

class HaxeArrayTreeToEntityTypePathPair
{
    public var typeInfo(default, null):EntityTypeInfomation;
	public var arraytreeToEntityPath(default, null):HaxeArrayTreeToEntityTypePath;
	
	public function new(typeInfo:EntityTypeInfomation, arraytreeToEntityPath:HaxeArrayTreeToEntityTypePath) 
	{
		this.typeInfo = typeInfo;
        this.arraytreeToEntityPath = arraytreeToEntityPath;
	}
}
