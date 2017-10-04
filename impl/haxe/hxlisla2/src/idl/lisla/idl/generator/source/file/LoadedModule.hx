package arraytree.idl.generator.source.file;
import arraytree.data.meta.core.BlockData;
import arraytree.idl.std.entity.idl.Idl;
import arraytree.project.FileSourceMap;
import arraytree.project.ProjectRootAndFilePath;

class LoadedModule
{
	public var data(default, null):Idl;
	public var fileSourceMap(default, null):FileSourceMap;
	
	public function new(moduleBlock:BlockData<Idl>, filePath:ProjectRootAndFilePath) 
	{
		this.data = data.data;
		this.fileSourceMap = new FileSourceMap(data.sourceMap);
	}
}
