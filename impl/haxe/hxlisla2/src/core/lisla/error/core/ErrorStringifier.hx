package lisla.error.core;
import haxe.ds.Option;
import haxe.macro.Expr.Position;
import lisla.project.FilePathFromProjectRoot;
import lisla.data.meta.position.Range;
import lisla.data.meta.position.SourceMap;
import lisla.project.ProjectRootAndFilePath;

class ErrorStringifier
{
    public static function fromElementaryError(errorHolder:ElementaryErrorHolder):String
    {
        var error = errorHolder.getElementaryError();
        return error.getMessage() + " (" + error.getErrorName()  + ")";
    }
    
    public static function fromInlineError(errorHolder:InlineErrorHolder):String
    {
        var error = errorHolder.getInlineError();
        var range = error.getOptionRange();
        var result = fromElementaryError(error);
       
        switch (range)
        {
            case Option.Some(_range):
                result = "range " + _range.toString() + " : " + result;
                
            case Option.None:
        }
        
        return result;
    }
    
    public static function fromInlineErrorWithSourceMap(errorHolder:InlineErrorHolder, sourceMap:SourceMap):String
    {
        var error = errorHolder.getInlineError();
        var range = error.getOptionRange();
        var result = fromElementaryError(error);
       
        switch (range)
        {
            case Option.Some(_range):
                var localSourceMap = sourceMap.mergeRange(_range);
                result = "line " + localSourceMap.getLinesString() + " : range " + localSourceMap.getRangesString() + " : " + result;
                
            case Option.None:
        }
        
        return result;
    }
    
    public static function fromBlockError(errorHolder:BlockErrorHolder):String
    {
        var error = errorHolder.getBlockError();
        var sourceMap = Option.None;//error.getOptionSourceMap();
        
        return switch (sourceMap)
        {
            case Option.Some(_sourceMap):
                fromInlineErrorWithSourceMap(error, _sourceMap);
                
            case Option.None:
                fromInlineError(error);
        }
    }
    
    
    public static function fromBlockErrorWithFilePath(
        errorHolder:BlockErrorHolder, 
        filePath:ProjectRootAndFilePath):String
    {
        var error = errorHolder.getBlockError();
        var sourceMap = error.getOptionSourceMap();
        
        return "file : " + filePath.toString() + " : " + fromBlockError(error);
    }
    
    public static function fromFileError(errorHolder:FileErrorHolder):String
    {
        var error = errorHolder.getFileError();
        var filePath = error.getOptionFilePath();
        
        return switch (filePath)
        {
            case Option.Some(_filePath):
                fromBlockErrorWithFilePath(error, _filePath);
                
            case Option.None:
                fromBlockError(error);
        }
    }
}
