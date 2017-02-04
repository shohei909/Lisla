package litll.idl.generator.output.delitll.match;
import haxe.ds.Option;
import haxe.macro.Expr;
import litll.core.Litll;
import litll.idl.exception.IdlException;
import litll.idl.generator.source.IdlSourceProvider;
import litll.idl.std.data.idl.ArgumentKind;
import litll.idl.std.data.idl.EnumConstructor;
import litll.idl.std.data.idl.EnumConstructorKind;
import litll.idl.std.data.idl.StructElement;
import litll.idl.std.data.idl.StructFieldKind;
import litll.idl.std.data.idl.TupleElement;
import litll.idl.std.data.idl.TypeName;
import litll.idl.std.data.idl.TypeReference;
import litll.idl.std.data.idl.FollowedTypeDefinition;
using litll.idl.std.tools.idl.TypeReferenceTools;

class DelitllfyGuardCondition 
{
    private var min:Int = 0;
    private var max:Option<Int>;
    private var conditions:Array<ConditionKind>;
    
    public function new (min:Int, max:Option<Int>, conditions:Array<ConditionKind>)
    {
        this.min = min;
        this.max = max;
        this.conditions = conditions;
    }
    
    public static function any():DelitllfyGuardCondition
    {
        return new DelitllfyGuardCondition(0, Option.None, []);
    }
    
    public static function createForTuple(elements:Array<TupleElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):DelitllfyGuardCondition 
    {
        var condition = new DelitllfyGuardCondition(0, Option.Some(0), []);
        condition.processTuple(elements, source, definitionParameters);
        return condition;
    }
    
    public static function createForStruct(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):DelitllfyGuardCondition 
    {
        var condition = new DelitllfyGuardCondition(0, Option.Some(0), []);
        condition.processStruct(elements, source, definitionParameters);
        return condition;
    }

    private function processTuple(elements:Array<TupleElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Void
    {
        for (element in elements)
        {
            switch (element)
            {
                case TupleElement.Label(value):
                    add(ConditionKind.Const([value.data => true]));
                    
                case TupleElement.Argument(argument):
                    switch [argument.name.kind, argument.defaultValue]
                    {
                        case [ArgumentKind.Normal, Option.None]:
                            add(resolveTypeCondition(argument.type, source, definitionParameters));
                            
                        case [ArgumentKind.Optional, Option.None] 
                            | [ArgumentKind.Normal, Option.Some(_)]:
                            addMax();
                        
                        case [ArgumentKind.Rest, Option.None]:
                            max = Option.None;
                            
                        case [ArgumentKind.Inline, Option.None]:
                            switch (argument.type.follow(source, definitionParameters))
                            {
                                case FollowedTypeDefinition.Arr(_):
                                    max = Option.None;
                                    
                                case FollowedTypeDefinition.Struct(elements):
                                    processStruct(elements, source, definitionParameters);
                                    
                                case FollowedTypeDefinition.Tuple(elements):
                                    processTuple(elements, source, definitionParameters);
                                    
                                case FollowedTypeDefinition.Str:
                                    throw new IdlException("string can't be inlined");
                                    
                                case FollowedTypeDefinition.Enum(_):
                                    max = Option.None;
                            }
                            
                        case [ArgumentKind.Rest, Option.Some(_)] 
                            | [ArgumentKind.Inline, Option.Some(_)]
                            | [ArgumentKind.Optional, Option.Some(_)]:
                            throw new IdlException("unsupported default value kind: " + argument.name.kind);
                    }
            }
        }
    }
    
    private function processStruct(elements:Array<StructElement>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):Void
    {
        var condition = ConditionKind.Never;
        var start = min;
        
        function _processStruct(elements:Array<StructElement>):Void
        {
            for (element in elements)
            {
                switch (element)
                {
                    case StructElement.Field(field):
                        switch [field.name.kind, field.defaultValue]
                        {
                            case [StructFieldKind.Normal, Option.None]:
                                condition = merge(condition, ConditionKind.Arr);
                                _add();
                                
                            case [StructFieldKind.Normal, Option.Some(_)]
                                | [StructFieldKind.Optional, Option.None]
                                | [StructFieldKind.Inline, Option.Some(_)]
                                | [StructFieldKind.OptionalInline, Option.None] :
                                addMax();
                                
                            case [StructFieldKind.Array, Option.None]
                                | [StructFieldKind.ArrayInline, Option.None]:
                                max = Option.None;
                                
                            case [StructFieldKind.Inline, Option.None]:
                                switch (field.type.follow(source, definitionParameters))
                                {
                                    case FollowedTypeDefinition.Str:
                                        condition = merge(condition, ConditionKind.Str);
                                    
                                    case FollowedTypeDefinition.Struct(_)
                                        | FollowedTypeDefinition.Arr(_)
                                        | FollowedTypeDefinition.Tuple(_):
                                        condition = merge(condition, ConditionKind.Arr);
                                        _add();
                                        
                                    case FollowedTypeDefinition.Enum(constructors):
                                        condition = merge(condition, resolveEnumCondition(constructors, source, definitionParameters));
                                        _add();
                                }
                                
                            case [StructFieldKind.Merge, Option.None]:
                                switch (field.type.follow(source, definitionParameters))
                                {
                                    case FollowedTypeDefinition.Struct(elements):
                                        _processStruct(elements);
                                        
                                    case FollowedTypeDefinition.Enum(_)
                                        | FollowedTypeDefinition.Arr(_)
                                        | FollowedTypeDefinition.Tuple(_)
                                        | FollowedTypeDefinition.Str:
                                        throw new IdlException("merge field is not supported " + field.type.getTypeReferenceName());
                                }
                               
                            case [StructFieldKind.ArrayInline, Option.Some(_)]
                                | [StructFieldKind.OptionalInline, Option.Some(_)]
                                | [StructFieldKind.Array, Option.Some(_)]
                                | [StructFieldKind.Optional, Option.Some(_)]
                                | [StructFieldKind.Merge, Option.Some(_)]:
                                throw new IdlException("unsupported default value kind: " + field.name.kind);
                        }
                        
                    case StructElement.Label(name):
                        switch (name.kind)
                        {
                            case StructFieldKind.Normal:
                                condition = merge(condition, ConditionKind.Const([name.name => true]));
                                _add();
                                
                            case StructFieldKind.Array:
                                max = Option.None;
                                
                            case StructFieldKind.Optional:
                                addMax();
                                
                            case StructFieldKind.Inline:
                                throw new IdlException("inline suffix(<) for label is not supported");
                                
                            case StructFieldKind.ArrayInline:
                                throw new IdlException("array inline suffix(<..) for label is not supported");
                                
                            case StructFieldKind.OptionalInline:
                                throw new IdlException("optional inline suffix(<?) for label is not supported");
                                
                            case StructFieldKind.Merge:
                                throw new IdlException("merge suffix(<<) for label is not supported");
                        }
                        
                    case StructElement.NestedLabel(name):
                        switch (name.kind)
                        {
                            case StructFieldKind.Normal:
                                condition = merge(condition, ConditionKind.Arr);
                                _add();
                                
                            case StructFieldKind.Array:
                                max = Option.None;
                                
                            case StructFieldKind.Optional:
                                addMax();
                                
                            case StructFieldKind.Inline:
                                throw new IdlException("inline suffix(<) for label is not supported");
                                
                            case StructFieldKind.ArrayInline:
                                throw new IdlException("array inline suffix(<..) for label is not supported");
                                
                            case StructFieldKind.OptionalInline:
                                throw new IdlException("optional inline suffix(<?) for label is not supported");
                                
                            case StructFieldKind.Merge:
                                throw new IdlException("merge suffix(<<) for label is not supported");
                        }
                }
            }
        }
        
        if (isSolid())
        {
            for (i in start...min)
            {
                conditions.push(condition);
            }
        }
    }
    
    public function getConditionExprs(dataExpr:Expr):Array<Expr>
    {
        var result = [];
        var minValue = {
            expr: ExprDef.EConst(Constant.CInt(Std.string(min))),
            pos: null,
        }
        
        switch (max)
        {
            case Option.Some(max) if (max == min):
                result.push(macro $dataExpr.length == $minValue);
                
            case Option.Some(max):
                var maxValue = {
                    expr: ExprDef.EConst(Constant.CInt(Std.string(max))),
                    pos: null,
                }
                result.push(macro $minValue <= $dataExpr.length);
                result.push(macro $dataExpr.length <= $maxValue);
                
            case Option.None:
                if (0 < min)
                {
                    result.push(macro $minValue <= $dataExpr.length);
                }
        }
        
        
        for (i in 0...conditions.length)
        {
            var condition = conditions[i];
            var index = {
                expr: ExprDef.EConst(Constant.CInt(Std.string(i))),
                pos: null,
            }
            inline function addConst(strings:Map<String, Bool>):Void
            {
                for (key in strings.keys())
                {
                    var string = {
                        expr: ExprDef.EConst(Constant.CString(key)),
                        pos: null,
                    }
                    result.push(macro $dataExpr.data[$index].match(litll.core.Litll.Str(_.data => $string)));
                }
            }
            
            switch (condition)
            {
                case ConditionKind.Const(strings):
                    addConst(strings);
                    
                case ConditionKind.Str:
                    result.push(macro $dataExpr.data[$index].match(litll.core.Litll.Str(_)));
                    
                case ConditionKind.Arr:
                    result.push(macro $dataExpr.data[$index].match(litll.core.Litll.Arr(_)));
                    
                case ConditionKind.ArrOrConst(strings):
                    addConst(strings);
                    result.push(macro $dataExpr.data[$index].match(litll.core.Litll.Arr(_)));
                    
                case ConditionKind.Never:
                    result.push(macro false);
                    
                case ConditionKind.Always:
            }
        }
        
        return result;
    }
    
    private inline function add(kind:ConditionKind):Void
    {
        if (isSolid())
        {
            conditions.push(kind);
        }
        _add();
    }
    private inline function _add():Void
    {
        min++;
        addMax();
    }
    private inline function addMax():Void
    {
        switch (max)
        {
            case Option.Some(value):
                max = Option.Some(value + 1);
                
            case Option.None:
        }
    }
    
    public function isSolid():Bool
    {
        return switch (max)
        {
            case Option.Some(value) if (value == min):
                true;
                
            case _:
                false;
        }
    }
    
    private function resolveTypeCondition(type:TypeReference, source:IdlSourceProvider, definitionParameters:Array<TypeName>):ConditionKind
    {
        return switch (type.follow(source, definitionParameters))
        {
            case FollowedTypeDefinition.Struct(elements):
                ConditionKind.Arr;
                
            case FollowedTypeDefinition.Str:
                ConditionKind.Str;
                
            case FollowedTypeDefinition.Arr(_)
                | FollowedTypeDefinition.Tuple(_):
                ConditionKind.Arr;
                
            case FollowedTypeDefinition.Enum(constructors):
                resolveEnumCondition(constructors, source, definitionParameters);
        }
    }
    
    private function resolveEnumCondition(constructors:Array<EnumConstructor>, source:IdlSourceProvider, definitionParameters:Array<TypeName>):ConditionKind
    {
        var kind1 = ConditionKind.Never;
        
        for (constructor in constructors)
        {
            var kind2 = switch (constructor)
            {
                case EnumConstructor.Primitive(name):
                    switch (name.kind)
                    {
                        case EnumConstructorKind.Normal:
                            ConditionKind.Const([name.name => true]);
                    
                        case EnumConstructorKind.Tuple:
                            throw new IdlException("tuple is not allowed for primitive enum constructor");
                            
                        case EnumConstructorKind.Inline:
                            throw new IdlException("inline is not allowed for primitive enum constructor");
                    }
                    
                case EnumConstructor.Parameterized(parameterized):
                    switch (parameterized.name.kind)
                    {
                        case EnumConstructorKind.Normal | EnumConstructorKind.Tuple:
                            ConditionKind.Arr;
                    
                        case EnumConstructorKind.Inline:
                            var elements = parameterized.elements;
                            if (elements.length != 1)
                            {
                                throw new IdlException("inline target type number must be one. but actual " + elements.length);
                            }
                            
                            switch (elements[0])
                            {
                                case TupleElement.Argument(argument):
                                    resolveTypeCondition(argument.type, source, definitionParameters);
                                    
                                case TupleElement.Label(litllString):
                                    ConditionKind.Const([litllString.data => true]);
                            }
                    }
            }
            
            kind1 = merge(kind1, kind2);
        }
        
        return kind1;
    }
    
    private static function merge(kind1:ConditionKind, kind2:ConditionKind):ConditionKind
    {
        return switch [kind1, kind2]
        {
            case [Always, _]
                | [_, Always]:
                Always;
                
            case [Never, kind]
                | [kind, Never]:
                kind;
                   
            case [Str, Str]
                | [Const(_), Str]
                | [Str, Const(_)]:
                Str;
                
            case [Arr, Arr]:
                Arr;
                
            case [Const(strings1), Const(strings2)]:
                Const(mergeStringSet(strings1, strings2));
                
            case [ArrOrConst(strings1), ArrOrConst(strings2)]
                | [Const(strings1), ArrOrConst(strings2)]
                | [ArrOrConst(strings1), Const(strings2)]:
                ArrOrConst(mergeStringSet(strings1, strings2));
                
            case [ArrOrConst(strings1), Arr]
                | [Arr, ArrOrConst(strings1)]
                | [Const(strings1), Arr]
                | [Arr, Const(strings1)]:
                ArrOrConst(strings1);
                
            case [Str, Arr]
                | [Arr, Str]
                | [Str, ArrOrConst(_)]
                | [ArrOrConst(_), Str]:
                Always;
        }
    }
    
    private static function mergeStringSet(strings1:Map<String, Bool>, strings2:Map<String, Bool>):Map<String, Bool>
    {
        var result = new Map();
        for (key in strings1.keys())
        {
            result[key] = true;
        }
        for (key in strings2.keys())
        {
            result[key] = true;
        }
        return result;
    }
    
}

private enum ConditionKind
{
    Const(strings:Map<String, Bool>);
    Str;
    Arr;
    ArrOrConst(strings:Map<String, Bool>);
    Always;
    Never;
}
