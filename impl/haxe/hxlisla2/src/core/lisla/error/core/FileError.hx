package lisla.error.core;
import haxe.ds.Option;
import lisla.project.FilePathFromProjectRoot;
import lisla.project.ProjectRootAndFilePath;

interface FileError 
    extends FileErrorHolder
    extends BlockErrorHolder
{
    public function getOptionFilePath():Option<ProjectRootAndFilePath>;
}
