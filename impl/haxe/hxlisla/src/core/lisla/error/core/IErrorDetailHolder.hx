package lisla.error.core;
import haxe.ds.Option;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.project.LocalPath;
import lisla.project.ProjectRootDirectory;

interface IErrorDetailHolder 
{    
    public function getDetail():IErrorDetail;
}
