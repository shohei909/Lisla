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
    
    public static function _getConditions(
        field:StructField, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        conditions:Array<DelitllfyCaseCondition>,
        history:Array<String>
    ):Option<GetConditionErrorKind>
    {
        return switch [field.name.kind, field.defaultValue]
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
                        conditions.push(DelitllfyCaseCondition.Arr(builder.build()));
                        Option.None;
                        
                    case Result.Err(error):
                        Option.Some(error);
                }                
                
            case [StructFieldKind.Inline, Option.None]:
                switch (field.type.follow(source, definitionParameters))
                {
                    case Result.Ok(data):
                        switch (FollowedTypeDefinitionTools._getConditions(data, source, definitionParameters, conditions, []))
                        {
                            case Option.None:
                                Option.None;
                                
                            case Option.Some(error):
                                Option.Some(error);
                        }
                        
                    case Result.Err(error):
                        Option.Some(GetConditionErrorKind.Follow(error));
                }
                
            case [StructFieldKind.Merge, Option.None]:
                var path = field.type.getTypePath();
                var pathName = path.toString();
                
                if (history.indexOf(pathName) != -1)
                {
                    Option.Some(errorKind(field.name, StructFieldSuffixErrorKind.LoopedMerge(field.type)));
                }
                else
                {
                    switch (field.type.follow(source, definitionParameters))
                    {
                        case Result.Ok(data):
                            switch (data)
                            {
                                case FollowedTypeDefinition.Struct(elements):
                                    StructTools._getConditionsForMerge(
                                        elements, 
                                        source, 
                                        definitionParameters, 
                                        conditions,
                                        history.concat([pathName])
                                    );
                                    
                                case FollowedTypeDefinition.Enum(_)
                                    | FollowedTypeDefinition.Arr(_)
                                    | FollowedTypeDefinition.Tuple(_)
                                    | FollowedTypeDefinition.Str:
                                    Option.Some(errorKind(field.name, StructFieldSuffixErrorKind.InvalidMergeTarget(field.type)));
                            }
                            
                        case Result.Err(error):
                            Option.Some(GetConditionErrorKind.Follow(error));
                    }
                }
               
            case [StructFieldKind.ArrayInline, Option.Some(_)]
                | [StructFieldKind.OptionalInline, Option.Some(_)]
                | [StructFieldKind.Array, Option.Some(_)]
                | [StructFieldKind.Optional, Option.Some(_)]
                | [StructFieldKind.Merge, Option.Some(_)]:
                Option.Some(errorKind(field.name, StructFieldSuffixErrorKind.UnsupportedDefault(field.name.kind)));
        }
    }
    
    public static function _getGuardForStruct(field:StructField, source:IdlSourceProvider, definitionParameters:Array<TypeName>, builder:DelitllfyGuardConditionBuilder):Option<GetConditionErrorKind>
    {
        return switch [field.name.kind, field.defaultValue]
        {
            case [StructFieldKind.Normal, Option.None]:
                builder.add(DelitllfyGuardConditionKind.Arr);
                Option.None;
                
            case [StructFieldKind.Normal, Option.Some(_)]
                | [StructFieldKind.Optional, Option.None]
                | [StructFieldKind.Inline, Option.Some(_)]
                | [StructFieldKind.OptionalInline, Option.None] :
                builder.addMax();
                Option.None;
                
            case [StructFieldKind.Array, Option.None]
                | [StructFieldKind.ArrayInline, Option.None]:
                builder.unlimit();
                Option.None;
                
            case [StructFieldKind.Inline, Option.None]:
                switch (field.type.follow(source, definitionParameters))
                {
                    case Result.Ok(data):
                        switch (data)
                        {
                            case FollowedTypeDefinition.Str:
                                builder.add(DelitllfyGuardConditionKind.Str);
                                Option.None;
                                
                            case FollowedTypeDefinition.Struct(_)
                                | FollowedTypeDefinition.Arr(_)
                                | FollowedTypeDefinition.Tuple(_):
                                builder.add(DelitllfyGuardConditionKind.Arr);
                                Option.None;
                                
                            case FollowedTypeDefinition.Enum(constructors):
                                switch (constructors.getGuardConditionKind(source, definitionParameters))
                                {
                                    case Result.Ok(data):
                                        builder.add(data);
                                        Option.None;
                                        
                                    case Result.Err(error):
                                        Option.Some(error);
                                }
                        }
                        
                    case Result.Err(error):
                        Option.Some(GetConditionErrorKind.Follow(error));
                }
                
            case [StructFieldKind.Merge, Option.None]:
                switch (field.type.follow(source, definitionParameters))
                {
                    case Result.Ok(data):
                        switch (data)
                        {
                            case FollowedTypeDefinition.Struct(elements):
                                elements._getGuard(source, definitionParameters, builder);
                                
                            case FollowedTypeDefinition.Enum(_)
                                | FollowedTypeDefinition.Arr(_)
                                | FollowedTypeDefinition.Tuple(_)
                                | FollowedTypeDefinition.Str:
                                Option.Some(errorKind(field.name, StructFieldSuffixErrorKind.InvalidMergeTarget(field.type)));
                        }
                        
                    case Result.Err(error):
                        Option.Some(GetConditionErrorKind.Follow(error));
                }
               
            case [StructFieldKind.ArrayInline, Option.Some(_)]
                | [StructFieldKind.OptionalInline, Option.Some(_)]
                | [StructFieldKind.Array, Option.Some(_)]
                | [StructFieldKind.Optional, Option.Some(_)]
                | [StructFieldKind.Merge, Option.Some(_)]:
                Option.Some(errorKind(field.name, StructFieldSuffixErrorKind.UnsupportedDefault(field.name.kind)));
        }
    }
}
