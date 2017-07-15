package lisla.data.meta.position;
import lisla.data.meta.position.Range;

class DataWithRange<DataType>
{
    public var data(default, null):DataType;
    public var range(default, null):Range;
    
    public function new(data:DataType, range:Range) 
    {
        this.data = data;
        this.range = range;
    }
    
    public function map<NewDataType>(func:DataType->NewDataType):DataWithRange<NewDataType>
    {
        return new DataWithRange(func(data), range);
    }
}
