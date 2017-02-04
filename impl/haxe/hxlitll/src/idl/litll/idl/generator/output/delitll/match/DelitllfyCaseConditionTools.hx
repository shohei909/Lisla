package litll.idl.generator.output.delitll.match;
import haxe.ds.Option;
import haxe.macro.Expr.Case;
import litll.core.LitllString;
import litll.idl.exception.IdlException;
import litll.idl.generator.output.delitll.match.DelitllfyGuardCondition;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.generator.source.IdlSourceReader;
import litll.idl.std.data.idl.Argument;
import litll.idl.std.data.idl.ArgumentName;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorKind;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.TypeName;
using litll.idl.std.tools.idl.TypeReferenceTools;

class DelitllfyCaseConditionTools 
{
    public static function createForFollowedType(type:FollowedTypeDefinition, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Array<DelitllfyCaseCondition>
    {
        var result:Array<DelitllfyCaseCondition> = [];
        _createForInlineType(result, type, source, definitionParameters);
        return result;
    }   
    
    private static function _createForInlineType(result:Array<DelitllfyCaseCondition>, type:FollowedTypeDefinition, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Void
    {
        inline function addTuple(elements:Array<TupleElement>):Void
        {
            result.push(DelitllfyCaseCondition.Arr(DelitllfyGuardCondition.createForTuple(elements, source, definitionParameters)));
        }
        switch (type)
        {
            case FollowedTypeDefinition.Arr(_):
                result.push(DelitllfyCaseCondition.Arr(DelitllfyGuardCondition.any()));
                
            case FollowedTypeDefinition.Str:
                result.push(DelitllfyCaseCondition.Str);
                
            case FollowedTypeDefinition.Tuple(elements):
                addTuple(elements);
                
            case FollowedTypeDefinition.Enum(constructors):
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
                            
                                case EnumConstructorKind.Inline:
                                    var elements = parameterized.elements;
                                    if (elements.length != 1)
                                    {
                                        throw new IdlException("inline target type number must be one. but actual " + elements.length);
                                    }
                                    
                                    switch (elements[0])
                                    {
                                        case TupleElement.Argument(argument):
                                            var followedType = argument.type.follow(source, definitionParameters);
                                            _createForInlineType(result, followedType, source, definitionParameters);
                                            
                                        case TupleElement.Label(litllString):
                                            result.push(DelitllfyCaseCondition.Const(litllString.data));
                                    }
                            }
                    }
                }
                
            case FollowedTypeDefinition.Struct(elements):
                result.push(DelitllfyCaseCondition.Arr(DelitllfyGuardCondition.createForStruct(elements, source, [])));
        }
    }
}
