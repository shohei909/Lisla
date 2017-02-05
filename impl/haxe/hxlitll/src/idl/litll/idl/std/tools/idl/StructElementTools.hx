package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionBuilder;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionKind;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructField;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.StructFieldName;
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
    
    private static inline function errorKind(name:StructFieldName, kind:StructFieldSuffixErrorKind):GetConditionErrorKind
    {
        return GetConditionErrorKind.StructFieldSuffix(
            new StructFieldSuffixError(name, kind)
        );
    }
    
    public static function _getGuard(element:StructElement, source:IdlSourceProvider, definitionParameters:Array<TypeName>, builder:DelitllfyGuardConditionBuilder):Option<GetConditionErrorKind>
    {
        switch (element)
        {
            case StructElement.Field(field):
                switch [field.name.kind, field.defaultValue]
                {
                    case [StructFieldKind.Normal, Option.None]:
                        builder.add(DelitllfyGuardConditionKind.Arr);
                        
                    case [StructFieldKind.Normal, Option.Some(_)]
                        | [StructFieldKind.Optional, Option.None]
                        | [StructFieldKind.Inline, Option.Some(_)]
                        | [StructFieldKind.OptionalInline, Option.None] :
                        builder.addMax();
                        
                    case [StructFieldKind.Array, Option.None]
                        | [StructFieldKind.ArrayInline, Option.None]:
                        builder.unlimit();
                        
                    case [StructFieldKind.Inline, Option.None]:
                        switch (field.type.follow(source, definitionParameters))
                        {
                            case Result.Ok(data):
                                switch (data)
                                {
                                    case FollowedTypeDefinition.Str:
                                        builder.add(DelitllfyGuardConditionKind.Str);
                                        
                                    case FollowedTypeDefinition.Struct(_)
                                        | FollowedTypeDefinition.Arr(_)
                                        | FollowedTypeDefinition.Tuple(_):
                                        builder.add(DelitllfyGuardConditionKind.Arr);
                                        
                                    case FollowedTypeDefinition.Enum(constructors):
                                        switch (constructors.getGuardConditionKind(source, definitionParameters))
                                        {
                                            case Result.Ok(data):
                                                builder.add(data);
                                                
                                            case Result.Err(error):
                                                return Option.Some(error);
                                        }
                                }
                                
                            case Result.Err(error):
                                return Option.Some(GetConditionErrorKind.Follow(error));
                        }
                        
                    case [StructFieldKind.Merge, Option.None]:
                        switch (field.type.follow(source, definitionParameters))
                        {
                            case Result.Ok(data):
                                switch (data)
                                {
                                    case FollowedTypeDefinition.Struct(elements):
                                        switch (elements._getGuard(source, definitionParameters, builder))
                                        {
                                            case Option.None:
                                                // continue
                                                
                                            case Option.Some(error):
                                                return Option.Some(error);
                                        }
                                        
                                    case FollowedTypeDefinition.Enum(_)
                                        | FollowedTypeDefinition.Arr(_)
                                        | FollowedTypeDefinition.Tuple(_)
                                        | FollowedTypeDefinition.Str:
                                        return Option.Some(errorKind(field.name, StructFieldSuffixErrorKind.InvelidMargeTarget(field.type)));
                                }
                                
                            case Result.Err(error):
                                return Option.Some(GetConditionErrorKind.Follow(error));
                        }
                       
                    case [StructFieldKind.ArrayInline, Option.Some(_)]
                        | [StructFieldKind.OptionalInline, Option.Some(_)]
                        | [StructFieldKind.Array, Option.Some(_)]
                        | [StructFieldKind.Optional, Option.Some(_)]
                        | [StructFieldKind.Merge, Option.Some(_)]:
                        return Option.Some(errorKind(field.name, StructFieldSuffixErrorKind.UnsupportedDefault(field.name.kind)));
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
}
