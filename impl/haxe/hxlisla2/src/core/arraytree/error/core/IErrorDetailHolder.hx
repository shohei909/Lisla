package arraytree.error.core;
import haxe.ds.Option;
import arraytree.data.meta.position.Range;
import arraytree.data.meta.position.SourceMap;
import arraytree.project.LocalPath;
import arraytree.project.ProjectRootDirectory;

interface IErrorDetailHolder 
{    
    public function getDetail():IErrorDetail;
}
