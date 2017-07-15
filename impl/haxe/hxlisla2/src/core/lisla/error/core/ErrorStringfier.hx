package lisla.error.core;
import lisla.data.meta.position.DataWithRange;
import lisla.data.meta.position.FilePathFromProjectRoot;
import lisla.data.meta.position.SourceMap;

class ErrorStringifier
{
    public static function fromErrorInRange<T:LislaError>(error:DataWithRange<T>):String
    {
        return "range " + error.range.toString() + " : " + error.data.toString() + " (" + error.data.getErrorName()  + ")";
    }
    
    public static function fromErrorInSource<T:LislaError>(sourceMap:SourceMap, error:DataWithRange<T>):String
    {
        var localSourceMap = sourceMap.localizeRange(error.range);
        return "line " + localSourceMap.getLinesString() + " : range " + localSourceMap.getRangesString() + " : " + error.data.toString() + " (" + error.data.getErrorName()  + ")";
    }
    
    public static function fromErrorInFile<T:LislaError>(filePath:FilePathFromProjectRoot, sourceMap:SourceMap, error:DataWithRange<T>):String
    {
        return "file : " + filePath + " : " + fromErrorInSource(sourceMap, error);
    }
}
