package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.LitllToEntityCaseCondition;
import litll.idl.generator.output.delitll.match.LitllToEntityGuardConditionBuilder;
import litll.idl.generator.output.delitll.match.LitllToEntityGuardConditionKind;
import litll.idl.generator.output.delitll.match.FirstElementCondition;
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
    
    public static function _getGuardForStruct(element:StructElement, source:IdlSourceProvider, definitionParameters:Array<TypeName>, builder:LitllToEntityGuardConditionBuilder):Option<GetConditionErrorKind>
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
                        builder.add(LitllToEntityGuardConditionKind.Const([name.name => true]));
                        
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
                        builder.add(LitllToEntityGuardConditionKind.Arr);
                        
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
    
    public static function getConditions(element:StructElement, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Array<LitllToEntityCaseCondition>, GetConditionErrorKind>
    {
        var conditions = [];
        return switch (_getConditions(element, source, definitionParameters, conditions, []))
        {
            case Option.Some(error):
                Result.Err(error);
                
            case Option.None:
                Result.Ok(conditions);
        }
    }
    
    public static function _getConditions(
        element:StructElement, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        conditions:Array<LitllToEntityCaseCondition>,
        history:Array<String>
    ):Option<GetConditionErrorKind>
    {
        return switch (element)
        {
            case StructElement.Label(name):
                switch (name.kind)
                {
                    case StructFieldKind.Normal | StructFieldKind.Array | StructFieldKind.Optional:
                        conditions.push(LitllToEntityCaseCondition.Const(name.name));
                        Option.None;
                        
                    case StructFieldKind.Inline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructFieldKind.ArrayInline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructFieldKind.OptionalInline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructFieldKind.Merge:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
                
            case StructElement.NestedLabel(name):
                switch (name.kind)
                {
                    case StructFieldKind.Normal | StructFieldKind.Array | StructFieldKind.Optional:
                        var builder = new LitllToEntityGuardConditionBuilder();
                        builder.add(LitllToEntityGuardConditionKind.Const([name.name => true]));
                        conditions.push(LitllToEntityCaseCondition.Arr(builder.build()));
                        Option.None;
                        
                    case StructFieldKind.Inline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructFieldKind.ArrayInline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructFieldKind.OptionalInline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructFieldKind.Merge:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
            
            case StructElement.Field(field):
                StructFieldTools._getConditions(field, source, definitionParameters, conditions, history);
        }
    }
    
    public static function applyFirstElementCondition(
        element:StructElement, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        condition:FirstElementCondition,
        history:Array<String>
    ):Option<GetConditionErrorKind>
    {
        return switch (element)
        {
            case StructElement.Label(name):
                switch (name.kind)
                {
                    case StructFieldKind.Normal:
                        condition.canBeEmpty = false;
                        condition.conditions.push(LitllToEntityCaseCondition.Const(name.name));
                        Option.None;
                        
                    case StructFieldKind.Array | StructFieldKind.Optional:
                        condition.conditions.push(LitllToEntityCaseCondition.Const(name.name));
                        Option.None;
                        
                    case StructFieldKind.Inline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructFieldKind.ArrayInline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructFieldKind.OptionalInline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructFieldKind.Merge:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
                
            case StructElement.NestedLabel(name):
                switch (name.kind)
                {
                    case StructFieldKind.Normal:
                        var builder = new LitllToEntityGuardConditionBuilder();
                        builder.add(LitllToEntityGuardConditionKind.Const([name.name => true]));
                        condition.canBeEmpty = false;
                        condition.conditions.push(LitllToEntityCaseCondition.Arr(builder.build()));
                        Option.None;
                        
                    case StructFieldKind.Array | StructFieldKind.Optional:
                        var builder = new LitllToEntityGuardConditionBuilder();
                        builder.add(LitllToEntityGuardConditionKind.Const([name.name => true]));
                        condition.conditions.push(LitllToEntityCaseCondition.Arr(builder.build()));
                        Option.None;
                        
                    case StructFieldKind.Inline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructFieldKind.ArrayInline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructFieldKind.OptionalInline:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructFieldKind.Merge:
                        Option.Some(errorKind(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
            
            case StructElement.Field(field):
                switch (field.name.kind)
                {
                    case StructFieldKind.Normal | StructFieldKind.Inline:
                        condition.canBeEmpty = false;
                        StructFieldTools._getConditions(field, source, definitionParameters, condition.conditions, history);
                        
                    case StructFieldKind.Array | StructFieldKind.Optional | StructFieldKind.ArrayInline | StructFieldKind.OptionalInline:
                        StructFieldTools._getConditions(field, source, definitionParameters, condition.conditions, history);
                        
                    case StructFieldKind.Merge:
                        switch (StructFieldTools.getStruct(field, source, definitionParameters, history))
                        {
                            case Result.Ok(elements):
                                elements.applyFirstElementCondition(source, definitionParameters, condition, history);
                                
                            case Result.Err(error):
                                Option.Some(error);
                        }
                }
        }
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
