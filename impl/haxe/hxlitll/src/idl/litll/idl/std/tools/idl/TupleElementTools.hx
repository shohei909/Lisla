package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionBuilder;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionKind;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.ArgumentKind;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.error.GetConditionErrorKind;

class TupleElementTools
{
    public static function mapOverTypeReference(element:TupleElement, func:TypeReference->TypeReference):TupleElement
    {
        return switch (element)
        {
            case TupleElement.Label(_):
                element;
                
            case TupleElement.Argument(argument):
                TupleElement.Argument(ArgumentTools.mapOverTypeReference(argument, func));
        }
    }
    
    public static function iterateOverTypeReference(element:TupleElement, func:TypeReference-> Void):Void
    {
        switch (element)
        {
            case TupleElement.Label(_):
                // nothing to do
                
            case TupleElement.Argument(argument):
                func(argument.type);
        }
    }
}
