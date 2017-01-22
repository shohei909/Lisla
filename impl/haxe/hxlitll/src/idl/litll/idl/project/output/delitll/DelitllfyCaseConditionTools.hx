package litll.idl.project.output.delitll;
import haxe.ds.Option;
import haxe.macro.Expr.Case;
import litll.core.LitllString;
import litll.idl.exception.IdlException;
import litll.idl.project.source.IdlSourceProvider;
import litll.idl.project.source.IdlSourceReader;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorKind;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.UnfoldedTypeDefinition;
using litll.idl.std.tools.idl.TypeReferenceTools;

class DelitllfyCaseConditionTools 
{
    public static function createForUnfoldedType(type:UnfoldedTypeDefinition, source:IdlSourceProvider):Array<DelitllfyCaseCondition>
    {
        var result:Array<DelitllfyCaseCondition> = [];
        _createForUnfoldedType(result, type, source);
        return result;
    }   
    
    private static function _createForUnfoldedType(result:Array<DelitllfyCaseCondition>, type:UnfoldedTypeDefinition, source:IdlSourceProvider):Void
    {
        inline function addTuple(elements:Array<TupleElement>):Void
        {
            result.push(DelitllfyCaseCondition.Arr(DelitllfyGuardCondition.createForTuple(elements, source, [])));
        }
        switch (type)
        {
            case UnfoldedTypeDefinition.Arr(_):
                result.push(DelitllfyCaseCondition.Arr(DelitllfyGuardCondition.any()));
                
            case UnfoldedTypeDefinition.Str:
                result.push(DelitllfyCaseCondition.Str);
                
            case UnfoldedTypeDefinition.Tuple(elements):
                addTuple(elements);
                
            case UnfoldedTypeDefinition.Enum(constructors):
                for (constuctor in constructors)
                {
                    switch (constuctor)
                    {
                        case EnumConstructor.Primitive(name):
                            result.push(DelitllfyCaseCondition.Const(name.name));
                            
                        case EnumConstructor.Parameterized(parameterized):
                            switch (parameterized.name.kind)
                            {
                                case EnumConstructorKind.Normal:
                                    var label = TupleElement.Label(new LitllString(parameterized.name.name, parameterized.name.tag));
                                    addTuple([label].concat(parameterized.elements));
                                    
                                case EnumConstructorKind.Tuple:
                                    addTuple(parameterized.elements);
                            
                                case EnumConstructorKind.Unfold:
                                    var elements = parameterized.elements;
                                    if (elements.length != 1)
                                    {
                                        throw new IdlException("unfold target type number must be one. but actual " + elements.length);
                                    }
                                    
                                    switch (elements[0])
                                    {
                                        case TupleElement.Argument(argument):
                                            var unfoldedType = argument.type.unfold(source, []);
                                            _createForUnfoldedType(result, unfoldedType, source);
                                            
                                        case TupleElement.Label(litllString):
                                            result.push(DelitllfyCaseCondition.Const(litllString.data));
                                    }
                            }
                    }
                }
                
            case UnfoldedTypeDefinition.Struct(elements):
                result.push(DelitllfyCaseCondition.Arr(DelitllfyGuardCondition.createForStruct(elements, source, [])));
        }
    }
}
