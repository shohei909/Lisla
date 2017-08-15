package lisla.idl.lislatext2entity;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.data.meta.core.BlockData;
import lisla.data.meta.core.FileData;
import lisla.project.FilePathFromProjectRoot;
import lisla.data.meta.position.LineIndexes;
import lisla.data.meta.position.RangeCollection;
import lisla.data.meta.position.SourceMap;
import lisla.project.ProjectRootAndFilePath;

import lisla.idl.lisla2entity.LislaToEntityConfig;
import lisla.idl.lisla2entity.LislaToEntityType;
import lisla.idl.lislatext2entity.error.LislaFileToEntityError;
import lisla.idl.lislatext2entity.error.LislaFileToEntityErrorKind;
import lisla.parse.ParserConfig;
import lisla.project.ProjectRootDirectory;

class LislaFileToEntityRunner 
{
    public static function run<T>(
        rootAndPath:ProjectRootAndFilePath, 
        processorType:LislaToEntityType<T>, 
        ?parseConfig:ParserConfig, 
        ?lislaToEntityConfig:LislaToEntityConfig
    ):Result<FileData<T>, Array<LislaFileToEntityError>>
    {
        var projectRoot = rootAndPath.projectRoot;
        var filePath = rootAndPath.filePath;
        
        if (!projectRoot.exists(filePath))
        {
            return Result.Error(
                [LislaFileToEntityError.ofFileNotFound(rootAndPath)]
            );
        }
        
        var text = projectRoot.getContent(filePath);
        return switch (LislaTextToEntityRunner.run(processorType, text, parseConfig, lislaToEntityConfig))
        {
            case Result.Ok(data):
                Result.Ok(data.mapWithFilePath(rootAndPath));
                
            case Result.Error(errors):
                Result.Error(
                    [for (error in errors) LislaFileToEntityError.ofLislaTextToEntity(error, rootAndPath)]
                );
        }
    }
}
