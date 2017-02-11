package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.DelitllfyCaseCondition;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionBuilder;
import litll.idl.generator.output.delitll.match.DelitllfyGuardConditionKind;
import litll.idl.std.data.idl.FollowedTypeDefinition;
import litll.idl.std.data.idl.StructElementName;
import litll.idl.std.data.idl.StructField;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.TypeName;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.error.GetConditionErrorKind;
import litll.idl.std.error.StructFieldSuffixError;
import litll.idl.std.error.StructFieldSuffixErrorKind;

class StructFieldTools 
{
    private static inline function errorKind(name:StructElementName, kind:StructFieldSuffixErrorKind):GetConditionErrorKind
    {
        return GetConditionErrorKind.StructFieldSuffix(
            new StructFieldSuffixError(name, kind)
        );
    }
    
    public static function _getConditions(field:StructField, source:IdlSourceProvider, definitionParameters:Array<TypeName>, conditions:Array<DelitllfyCaseCondition>):Option<GetConditionErrorKind>
    {
        switch [field.name.kind, field.defaultValue]
        {
            case [StructFieldKind.Normal, Option.None]
                | [StructFieldKind.Normal, Option.Some(_)]
                | [StructFieldKind.Optional, Option.None]
                | [StructFieldKind.Inline, Option.Some(_)]
                | [StructFieldKind.OptionalInline, Option.None]
                | [StructFieldKind.Array, Option.None]
                | [StructFieldKind.ArrayInline, Option.None]:
                var builder = new DelitllfyGuardConditionBuilder();
                builder.add(DelitllfyGuardConditionKind.Const([field.name.name => true]));
                switch (field.type.getGuardConditionKind(source, definitionParameters))
                {
                    case Result.Ok(data):
                        builder.add(data);
                        
                    case Result.Err(error):
                        return Option.Some(error);
                }
                conditions.push(DelitllfyCaseCondition.Arr(builder.build()));
                
            case [StructFieldKind.Inline, Option.None]:
                switch (field.type.follow(source, definitionParameters))
                {
                    case Result.Ok(data):
                        switch (FollowedTypeDefinitionTools._getConditions(data, source, definitionParameters, conditions))
                        {
                            case Option.None:
                                // continue
                                
                            case Option.Some(error):
                                return Option.Some(error);
                        }
                        
                    case Result.Err(error):
                        Result.Err(GetConditionErrorKind.Follow(error));
                }
                
            case [StructFieldKind.Merge, Option.None]:
                switch (field.type.follow(source, definitionParameters))
                {
                    case Result.Ok(data):
                        switch (data)
                        {
                            case FollowedTypeDefinition.Struct(elements):
                                switch (StructTools._getConditionsForMerge(elements, source, definitionParameters, conditions))
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
                        Result.Err(GetConditionErrorKind.Follow(error));
                }
               
            case [StructFieldKind.ArrayInline, Option.Some(_)]
                | [StructFieldKind.OptionalInline, Option.Some(_)]
                | [StructFieldKind.Array, Option.Some(_)]
                | [StructFieldKind.Optional, Option.Some(_)]
                | [StructFieldKind.Merge, Option.Some(_)]:
                Result.Err(errorKind(field.name, StructFieldSuffixErrorKind.UnsupportedDefault(field.name.kind)));
        }
        
        return Option.None;
    }
    
    public static function _getGuardForStruct(field:StructField, source:IdlSourceProvider, definitionParameters:Array<TypeName>, builder:DelitllfyGuardConditionBuilder):Option<GetConditionErrorKind>
    {
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
        
        return Option.None;
    }
}
