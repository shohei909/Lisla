package lisla.idl.generator.source.file;
import lisla.data.meta.core.BlockData;
import lisla.idl.std.entity.idl.Idl;
import lisla.project.FileSourceMap;
import lisla.project.ProjectRootAndFilePath;

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
