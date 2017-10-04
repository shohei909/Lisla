package arraytree.idl.arraytreetext2entity;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.data.meta.core.BlockData;
import arraytree.data.meta.core.FileData;
import arraytree.project.FilePathFromProjectRoot;
import arraytree.data.meta.position.LineIndexes;
import arraytree.data.meta.position.RangeCollection;
import arraytree.data.meta.position.SourceMap;
import arraytree.project.ProjectRootAndFilePath;

import arraytree.idl.arraytree2entity.ArrayTreeToEntityConfig;
import arraytree.idl.arraytree2entity.ArrayTreeToEntityType;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeFileToEntityError;
import arraytree.idl.arraytreetext2entity.error.ArrayTreeFileToEntityErrorKind;
import arraytree.parse.ParserConfig;
import arraytree.project.ProjectRootDirectory;

class ArrayTreeFileToEntityRunner 
{
    public static function run<T>(
        rootAndPath:ProjectRootAndFilePath, 
        processorType:ArrayTreeToEntityType<T>, 
        ?parseConfig:ParserConfig, 
        ?arraytreeToEntityConfig:ArrayTreeToEntityConfig
    ):Result<FileData<T>, Array<ArrayTreeFileToEntityError>>
    {
        var projectRoot = rootAndPath.projectRoot;
        var filePath = rootAndPath.filePath;
        
        if (!projectRoot.exists(filePath))
        {
            return Result.Error(
                [ArrayTreeFileToEntityError.ofFileNotFound(rootAndPath)]
            );
        }
        
        var text = projectRoot.getContent(filePath);
        return switch (ArrayTreeTextToEntityRunner.run(processorType, text, parseConfig, arraytreeToEntityConfig))
        {
            case Result.Ok(data):
                Result.Ok(data.mapWithFilePath(rootAndPath));
                
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) ArrayTreeFileToEntityError.ofArrayTreeTextToEntity(error, rootAndPath)]
                );
        }
    }
}
