package arraytree.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityCaseCondition;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardConditionBuilder;
import arraytree.idl.generator.output.arraytree2entity.match.ArrayTreeToEntityGuardConditionKind;
import arraytree.idl.generator.output.arraytree2entity.match.FirstElementCondition;
import arraytree.idl.generator.source.IdlSourceProvider;
import arraytree.idl.std.entity.idl.FollowedTypeDefinition;
import arraytree.idl.std.entity.idl.StructElement;
import arraytree.idl.std.entity.idl.StructField;
import arraytree.idl.std.entity.idl.StructElementKind;
import arraytree.idl.std.entity.idl.StructElementName;
import arraytree.idl.std.entity.idl.TypeName;
import arraytree.idl.std.entity.idl.TypeReference;
import arraytree.idl.std.error.GetConditionError;
import arraytree.idl.std.error.GetConditionErrorKind;
import arraytree.idl.std.error.StructFieldSuffixError;
import arraytree.idl.std.error.StructFieldSuffixErrorKind;

class StructElementTools 
{
    public static function getElementName(element:StructElement):StructElementName
    {
        return switch (element)
        {
            case StructElement.Field(field):
                field.name;
                
            case StructElement.Label(name) | StructElement.NestedLabel(name):
                name;
        }
    }
    
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
    
    private static inline function error(
        name:StructElementName, 
        kind:StructFieldSuffixErrorKind
    ):GetConditionError
    {
        return new GetConditionError(
            GetConditionErrorKind.StructFieldSuffix(
                new StructFieldSuffixError(name, kind)
            )
        );
    }
    
    public static function _getGuardForStruct(element:StructElement, source:IdlSourceProvider, definitionParameters:Array<TypeName>, builder:ArrayTreeToEntityGuardConditionBuilder):Option<GetConditionError>
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
                    case StructElementKind.Normal:
                        builder.add(ArrayTreeToEntityGuardConditionKind.Const([name.name => true]));
                        
                    case StructElementKind.Array:
                        builder.unlimit();
                        
                    case StructElementKind.Optional:
                        builder.addMax();
                        
                    case StructElementKind.Inline:
                        return Option.Some(error(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructElementKind.ArrayInline:
                        return Option.Some(error(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructElementKind.OptionalInline:
                        return Option.Some(error(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructElementKind.Merge:
                        return Option.Some(error(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
                
            case StructElement.NestedLabel(name):
                switch (name.kind)
                {
                    case StructElementKind.Normal:
                        builder.add(ArrayTreeToEntityGuardConditionKind.Arr);
                        
                    case StructElementKind.Array:
                        builder.unlimit();
                        
                    case StructElementKind.Optional:
                        builder.addMax();
                        
                    case StructElementKind.Inline:
                        return Option.Some(error(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructElementKind.ArrayInline:
                        return Option.Some(error(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructElementKind.OptionalInline:
                        return Option.Some(error(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructElementKind.Merge:
                        return Option.Some(error(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
        }
        
        return Option.None;
    }
    
    public static function getConditions(element:StructElement, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Result<Array<ArrayTreeToEntityCaseCondition>, GetConditionError>
    {
        var conditions = [];
        return switch (_getConditions(element, source, definitionParameters, conditions, []))
        {
            case Option.Some(error):
                Result.Error(error);
                
            case Option.None:
                Result.Ok(conditions);
        }
    }
    
    public static function _getConditions(
        element:StructElement, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        conditions:Array<ArrayTreeToEntityCaseCondition>,
        history:Array<String>
    ):Option<GetConditionError>
    {
        return switch (element)
        {
            case StructElement.Label(name):
                switch (name.kind)
                {
                    case StructElementKind.Normal | StructElementKind.Array | StructElementKind.Optional:
                        conditions.push(ArrayTreeToEntityCaseCondition.Const(name.name));
                        Option.None;
                        
                    case StructElementKind.Inline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructElementKind.ArrayInline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructElementKind.OptionalInline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructElementKind.Merge:
                        Option.Some(error(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
                
            case StructElement.NestedLabel(name):
                switch (name.kind)
                {
                    case StructElementKind.Normal | StructElementKind.Array | StructElementKind.Optional:
                        var builder = new ArrayTreeToEntityGuardConditionBuilder();
                        builder.add(ArrayTreeToEntityGuardConditionKind.Const([name.name => true]));
                        conditions.push(ArrayTreeToEntityCaseCondition.Arr(builder.build()));
                        Option.None;
                        
                    case StructElementKind.Inline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructElementKind.ArrayInline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructElementKind.OptionalInline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructElementKind.Merge:
                        Option.Some(error(name, StructFieldSuffixErrorKind.MergeForLabel));
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
    ):Option<GetConditionError>
    {
        return switch (element)
        {
            case StructElement.Label(name):
                switch (name.kind)
                {
                    case StructElementKind.Normal:
                        condition.canBeEmpty = false;
                        condition.conditions.push(ArrayTreeToEntityCaseCondition.Const(name.name));
                        Option.None;
                        
                    case StructElementKind.Array | StructElementKind.Optional:
                        condition.conditions.push(ArrayTreeToEntityCaseCondition.Const(name.name));
                        Option.None;
                        
                    case StructElementKind.Inline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructElementKind.ArrayInline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructElementKind.OptionalInline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructElementKind.Merge:
                        Option.Some(error(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
                
            case StructElement.NestedLabel(name):
                switch (name.kind)
                {
                    case StructElementKind.Normal:
                        var builder = new ArrayTreeToEntityGuardConditionBuilder();
                        builder.add(ArrayTreeToEntityGuardConditionKind.Const([name.name => true]));
                        condition.canBeEmpty = false;
                        condition.conditions.push(ArrayTreeToEntityCaseCondition.Arr(builder.build()));
                        Option.None;
                        
                    case StructElementKind.Array | StructElementKind.Optional:
                        var builder = new ArrayTreeToEntityGuardConditionBuilder();
                        builder.add(ArrayTreeToEntityGuardConditionKind.Const([name.name => true]));
                        condition.conditions.push(ArrayTreeToEntityCaseCondition.Arr(builder.build()));
                        Option.None;
                        
                    case StructElementKind.Inline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.InlineForLabel));
                        
                    case StructElementKind.ArrayInline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.ArrayInlineForLabel));
                        
                    case StructElementKind.OptionalInline:
                        Option.Some(error(name, StructFieldSuffixErrorKind.OptionalInlineForLabel));
                        
                    case StructElementKind.Merge:
                        Option.Some(error(name, StructFieldSuffixErrorKind.MergeForLabel));
                }
            
            case StructElement.Field(field):
                switch (field.name.kind)
                {
                    case StructElementKind.Normal | StructElementKind.Inline:
                        condition.canBeEmpty = false;
                        StructFieldTools._getConditions(field, source, definitionParameters, condition.conditions, history);
                        
                    case StructElementKind.Array | StructElementKind.Optional | StructElementKind.ArrayInline | StructElementKind.OptionalInline:
                        StructFieldTools._getConditions(field, source, definitionParameters, condition.conditions, history);
                        
                    case StructElementKind.Merge:
                        switch (StructFieldTools.getStruct(field, source, definitionParameters, history))
                        {
                            case Result.Ok(elements):
                                elements.applyFirstElementCondition(source, definitionParameters, condition, history);
                                
                            case Result.Error(error):
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
