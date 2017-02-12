package litll.idl.std.tools.idl;
import haxe.ds.Option;
import litll.core.ds.Result;
import litll.idl.generator.output.delitll.match.LitllToBackendCaseCondition;
import litll.idl.generator.output.delitll.match.LitllToBackendGuardConditionBuilder;
import litll.idl.generator.output.delitll.match.LitllToBackendGuardConditionKind;
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
        conditions:Array<LitllToBackendCaseCondition>,
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
                var builder = new LitllToBackendGuardConditionBuilder();
                builder.add(LitllToBackendGuardConditionKind.Const([field.name.name => true]));
                switch (field.type.getGuardConditionKind(source, definitionParameters))
                {
                    case Result.Ok(data):
                        builder.add(data);
                        conditions.push(LitllToBackendCaseCondition.Arr(builder.build()));
                        Option.None;
                        
                    case Result.Err(error):
                        Option.Some(error);
                }                
                
            case [StructFieldKind.Inline, Option.None]:
                switch (field.type.follow(source, definitionParameters))
                {
                    case Result.Ok(data):
                        FollowedTypeDefinitionTools._getConditions(data, source, definitionParameters, conditions, []);
                        
                    case Result.Err(error):
                        Option.Some(GetConditionErrorKind.Follow(error));
                }
                
            case [StructFieldKind.Merge, Option.None]:
                switch (getStruct(field, source, definitionParameters, history))
                {
                    case Result.Ok(elements):
                        var path = field.type.getTypePath();
                        var pathName = path.toString();
                        StructTools._getConditionsForMerge(
                            elements, 
                            source, 
                            definitionParameters, 
                            conditions,
                            history.concat([pathName])
                        );
                            
                    case Result.Err(error):
                        Option.Some(error);
                }
               
            case [StructFieldKind.ArrayInline, Option.Some(_)]
                | [StructFieldKind.OptionalInline, Option.Some(_)]
                | [StructFieldKind.Array, Option.Some(_)]
                | [StructFieldKind.Optional, Option.Some(_)]
                | [StructFieldKind.Merge, Option.Some(_)]:
                Option.Some(errorKind(field.name, StructFieldSuffixErrorKind.UnsupportedDefault(field.name.kind)));
        }
    }
    
    public static function getStruct(field:StructField, source:IdlSourceProvider, definitionParameters:Array<TypeName>, history:Array<String>):Result<Array<StructElement>, GetConditionErrorKind>
    {
        var path = field.type.getTypePath();
        var pathName = path.toString();
        return if (history.indexOf(pathName) != -1)
        {
            Result.Err(errorKind(field.name, StructFieldSuffixErrorKind.LoopedMerge(field.type)));
        }
        else
        {
            switch (field.type.follow(source, definitionParameters))
            {
                case Result.Ok(data):
                    switch (data)
                    {
                        case FollowedTypeDefinition.Struct(elements):
                            Result.Ok(elements);
                            
                        case FollowedTypeDefinition.Enum(_)
                            | FollowedTypeDefinition.Arr(_)
                            | FollowedTypeDefinition.Tuple(_)
                            | FollowedTypeDefinition.Str:
                            Result.Err(errorKind(field.name, StructFieldSuffixErrorKind.InvalidMergeTarget(field.type)));
                    }
                    
                case Result.Err(error):
                    Result.Err(GetConditionErrorKind.Follow(error));
            }
        }
    }
    
    public static function _getGuardForStruct(field:StructField, source:IdlSourceProvider, definitionParameters:Array<TypeName>, builder:LitllToBackendGuardConditionBuilder):Option<GetConditionErrorKind>
    {
        return switch [field.name.kind, field.defaultValue]
        {
            case [StructFieldKind.Normal, Option.None]:
                builder.add(LitllToBackendGuardConditionKind.Arr);
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
                                builder.add(LitllToBackendGuardConditionKind.Str);
                                Option.None;
                                
                            case FollowedTypeDefinition.Struct(_)
                                | FollowedTypeDefinition.Arr(_)
                                | FollowedTypeDefinition.Tuple(_):
                                builder.add(LitllToBackendGuardConditionKind.Arr);
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
