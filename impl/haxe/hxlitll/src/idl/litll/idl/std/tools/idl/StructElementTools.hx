package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionBuilder;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionKind;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructField;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.StructElementName;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.error.StructFieldSuffixError;
import litll.idl.std.error.StructFieldSuffixErrorKind;

class StructElementTools 
{
    public static function mapOverTypeReference(element:StructElement, func:TypeReference->TypeReference):StructElement
    {
        return switch (element)
        {
            case StructElement.Field(field):
                StructElement.Field(
                    new StructField(
                        field.name, 
                        func(field.type),
                        field.defaultValue
                    )
                );
                
            case StructElement.Label(_) | StructElement.NestedLabel(_):
                element;
        }
    }
    
    public static function iterateOverTypeReference(element:StructElement, func:TypeReference-> Void):Void
    {
        switch (element)
        {
            case StructElement.Field(field):
                func(field.type);
                
            case StructElement.Label(_) | StructElement.NestedLabel(_):
                // nothing to do
        }
    }
    
    private static inline function errorKind(name:StructElementName, kind:StructFieldSuffixErrorKind):GetConditionErrorKind
    {
        return GetConditionErrorKind.StructFieldSuffix(
            new StructFieldSuffixError(name, kind)
        );
    }
    
    public static function _getGuardForStruct(element:StructElement, source:IdlSourceProvider, definitionParameters:Array<TypeName>, builder:DelitllfyGuardConditionBuilder):Option<GetConditionErrorKind>
    {
        switch (element)
        {
            case StructElement.Field(field):
                switch (StructFieldTools._getGuardForStruct(field, source, definitionParameters, builder))
                {
                    case Option.None:
                        // continue
                        
                    case Option.Some(error):
                        return Option.Some(error);
                }
                
            case StructElement.Label(name):
                switch (name.kind)
                {
                    case StructFieldKind.Normal:
                        builder.add(DelitllfyGuardConditionKind.Const([name.name => true]));
                        
                    case StructFieldKind.Array:
                        builder.unlimit();
                        
                    case StructFieldKind.Optional:
                        builder.addMax();
                        
                    case StructFieldKind.Inline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructFieldKind.ArrayInline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructFieldKind.OptionalInline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructFieldKind.Merge:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
                
            case StructElement.NestedLabel(name):
                switch (name.kind)
                {
                    case StructFieldKind.Normal:
                        builder.add(DelitllfyGuardConditionKind.Arr);
                        
                    case StructFieldKind.Array:
                        builder.unlimit();
                        
                    case StructFieldKind.Optional:
                        builder.addMax();
                        
                    case StructFieldKind.Inline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructFieldKind.ArrayInline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructFieldKind.OptionalInline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructFieldKind.Merge:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
        }
        
        return Option.None;
    }
    
    public static function getConditions(element:StructElement, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Array<DelitllfyCaseCondition>, GetConditionErrorKind>
    {
        var conditions = [];
        return switch (_getConditions(element, source, definitionParameters, conditions))
        {
            case Option.Some(error):
                Result.Err(error);
                
            case Option.None:
                Result.Ok(conditions);
        }
    }
    
    public static function _getConditions(element:StructElement, source:IdlSourceProvider, definitionParameters:Array<TypeName>, conditions:Array<DelitllfyCaseCondition>):Option<GetConditionErrorKind>
    {
        switch (element)
        {
            case StructElement.Label(name):
                switch (name.kind)
                {
                    case StructFieldKind.Normal | StructFieldKind.Array | StructFieldKind.Optional:
                        conditions.push(DelitllfyCaseCondition.Const(name.name));
                        
                    case StructFieldKind.Inline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructFieldKind.ArrayInline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructFieldKind.OptionalInline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructFieldKind.Merge:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
                
            case StructElement.NestedLabel(name):
                switch (name.kind)
                {
                    case StructFieldKind.Normal | StructFieldKind.Array | StructFieldKind.Optional:
                        var builder = new DelitllfyGuardConditionBuilder();
                        builder.add(DelitllfyGuardConditionKind.Const([name.name => true]));
                        conditions.push(DelitllfyCaseCondition.Arr(builder.build()));
                    
                    case StructFieldKind.Inline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructFieldKind.ArrayInline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructFieldKind.OptionalInline:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructFieldKind.Merge:
                        return Option.Some(errorKind(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
            
            case StructElement.Field(field):
                StructFieldTools._getConditions(field, source, definitionParameters, conditions);
        }
        
        return Option.None;
    }
    
    public static function getName(field:StructElement):StructElementName
    {
        return switch (field)
        {
            case StructElement.Label(name) | StructElement.NestedLabel(name):
                name;
            
            case StructElement.Field(field):
                field.name;
        }
    }
}
