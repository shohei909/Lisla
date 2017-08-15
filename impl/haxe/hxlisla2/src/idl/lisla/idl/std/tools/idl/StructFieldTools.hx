package lisla.idl.std.tools.idl;
import haxe.ds.Option;
import hxext.ds.Result;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityCaseCondition;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardConditionBuilder;
import lisla.idl.generator.output.lisla2entity.match.LislaToEntityGuardConditionKind;
import lisla.idl.std.entity.idl.FollowedTypeDefinition;
import lisla.idl.std.entity.idl.StructElementName;
import lisla.idl.std.entity.idl.StructField;
import lisla.idl.std.entity.idl.StructElementKind;
import lisla.idl.std.entity.idl.TypeName;
import lisla.idl.generator.source.IdlSourceProvider;
import lisla.idl.std.entity.idl.StructElement;
import lisla.idl.std.error.GetConditionError;
import lisla.idl.std.error.GetConditionErrorKind;
import lisla.idl.std.error.StructFieldSuffixError;
import lisla.idl.std.error.StructFieldSuffixErrorKind;

class StructFieldTools 
{
    private static inline function error(name:StructElementName, kind:StructFieldSuffixErrorKind):GetConditionError
    {
        return new GetConditionError(
            GetConditionErrorKind.StructFieldSuffix(
                new StructFieldSuffixError(name, kind)
            )
        );
    }
   
    public static function _getConditions(
        field:StructField, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        conditions:Array<LislaToEntityCaseCondition>,
        history:Array<String>
    ):Option<GetConditionError>
    {
        return switch [field.name.kind, field.defaultValue]
        {
            case [StructElementKind.Normal, Option.None]
                | [StructElementKind.Normal, Option.Some(_)]
                | [StructElementKind.Optional, Option.None]
                | [StructElementKind.Inline, Option.Some(_)]
                | [StructElementKind.OptionalInline, Option.None]
                | [StructElementKind.Array, Option.None]
                | [StructElementKind.ArrayInline, Option.None]:
                var builder = new LislaToEntityGuardConditionBuilder();
                builder.add(LislaToEntityGuardConditionKind.Const([field.name.name => true]));
                switch (field.type.getGuardConditionKind(source, definitionParameters))
                {
                    case Result.Ok(data):
                        builder.add(data);
                        conditions.push(LislaToEntityCaseCondition.Arr(builder.build()));
                        Option.None;
                        
                    case Result.Error(error):
                        Option.Some(error);
                }                
                
            case [StructElementKind.Inline, Option.None]:
                switch (field.type.follow(source, definitionParameters))
                {
                    case Result.Ok(data):
                        FollowedTypeDefinitionTools._getConditions(data, source, definitionParameters, conditions, []);
                        
                    case Result.Error(error):
                        Option.Some(new GetConditionError(GetConditionErrorKind.Follow(error)));
                }
                
            case [StructElementKind.Merge, Option.None]:
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
                            
                    case Result.Error(error):
                        Option.Some(error);
                }
               
            case [StructElementKind.ArrayInline, Option.Some(_)]
                | [StructElementKind.OptionalInline, Option.Some(_)]
                | [StructElementKind.Array, Option.Some(_)]
                | [StructElementKind.Optional, Option.Some(_)]
                | [StructElementKind.Merge, Option.Some(_)]:
                Option.Some(error(field.name, StructFieldSuffixErrorKind.UnsupportedDefault(field.name.kind)));
        }
    }
    
    public static function getStruct(
        field:StructField, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        history:Array<String>
    ):Result<Array<StructElement>, GetConditionError>
    {
        var path = field.type.getTypePath();
        var pathName = path.toString();
        return if (history.indexOf(pathName) != -1)
        {
            Result.Error(error(field.name, StructFieldSuffixErrorKind.LoopedMerge(field.type)));
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
                            Result.Error(error(field.name, StructFieldSuffixErrorKind.InvalidMergeTarget(field.type)));
                    }
                    
                case Result.Error(error):
                    Result.Error(new GetConditionError(GetConditionErrorKind.Follow(error)));
            }
        }
    }
    
    public static function _getGuardForStruct(
        field:StructField, 
        source:IdlSourceProvider, 
        definitionParameters:Array<TypeName>, 
        builder:LislaToEntityGuardConditionBuilder
    ):Option<GetConditionError>
    {
        return switch [field.name.kind, field.defaultValue]
        {
            case [StructElementKind.Normal, Option.None]:
                builder.add(LislaToEntityGuardConditionKind.Arr);
                Option.None;
                
            case [StructElementKind.Normal, Option.Some(_)]
                | [StructElementKind.Optional, Option.None]
                | [StructElementKind.Inline, Option.Some(_)]
                | [StructElementKind.OptionalInline, Option.None] :
                builder.addMax();
                Option.None;
                
            case [StructElementKind.Array, Option.None]
                | [StructElementKind.ArrayInline, Option.None]:
                builder.unlimit();
                Option.None;
                
            case [StructElementKind.Inline, Option.None]:
                switch (field.type.follow(source, definitionParameters))
                {
                    case Result.Ok(data):
                        switch (data)
                        {
                            case FollowedTypeDefinition.Str:
                                builder.add(LislaToEntityGuardConditionKind.Str);
                                Option.None;
                                
                            case FollowedTypeDefinition.Struct(_)
                                | FollowedTypeDefinition.Arr(_)
                                | FollowedTypeDefinition.Tuple(_):
                                builder.add(LislaToEntityGuardConditionKind.Arr);
                                Option.None;
                                
                            case FollowedTypeDefinition.Enum(constructors):
                                switch (constructors.getGuardConditionKind(source, definitionParameters))
                                {
                                    case Result.Ok(data):
                                        builder.add(data);
                                        Option.None;
                                        
                                    case Result.Error(error):
                                        Option.Some(error);
                                }
                        }
                        
                    case Result.Error(error):
                        Option.Some(new GetConditionError(GetConditionErrorKind.Follow(error)));
                }
                
            case [StructElementKind.Merge, Option.None]:
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
                                Option.Some(error(field.name, StructFieldSuffixErrorKind.InvalidMergeTarget(field.type)));
                        }
                        
                    case Result.Error(error):
                        Option.Some(new GetConditionError(GetConditionErrorKind.Follow(error)));
                }
               
            case [StructElementKind.ArrayInline, Option.Some(_)]
                | [StructElementKind.OptionalInline, Option.Some(_)]
                | [StructElementKind.Array, Option.Some(_)]
                | [StructElementKind.Optional, Option.Some(_)]
                | [StructElementKind.Merge, Option.Some(_)]:
                Option.Some(error(field.name, StructFieldSuffixErrorKind.UnsupportedDefault(field.name.kind)));
        }
    }
}