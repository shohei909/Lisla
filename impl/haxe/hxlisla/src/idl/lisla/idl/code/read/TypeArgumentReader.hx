package lisla.idl.code.read;
import haxe.ds.Option;
import lisla.data.meta.core.MaybeTag;
import lisla.data.meta.core.WithTag;
import lisla.data.tree.array.StringArrayTree;
import lisla.idl.code.library.CodeTypeArgument;
import lisla.idl.code.library.CodeTypeArgumentElement;
import lisla.idl.code.tools.StringArrayTreeToCode;
import lisla.idl.code.tools.TypeReferenceToCode;
import lisla.idl.error.IdlLibraryErrorKind;
import lisla.idl.error.IdlModuleErrorKind;
import lisla.idl.library.ModuleToCodeContext;
import lisla.type.lisla.type.TypeArgument;
import lisla.type.lisla.type.TypeParameterDeclaration;
import lisla.type.lisla.type.VarRule;

class TypeArgumentReader 
{
    private var context:ModuleToCodeContext;
    private var arguments:Array<WithTag<TypeArgument>>;
    private var index:Int;
    private var tag:MaybeTag;
    
    public function new(
        arguments:Array<WithTag<TypeArgument>>,
        tag:MaybeTag,
        context:ModuleToCodeContext
    ) 
    {
        this.tag = tag;
        this.arguments = arguments;
        this.context = context;
        index = 0;
    }
    
    public function read(
        parameter:TypeParameterDeclaration
    ):CodeTypeArgument
    {
        var attribute = switch (parameter)
        {
            case TypeParameterDeclaration.Type(_type):
                _type.attributes;
                
            case TypeParameterDeclaration.Value(value):
                value.attributes;
        }
        
        inline function convert(value:WithTag<StringArrayTree>):WithTag<CodeTypeArgumentElement>
        {
            return switch (parameter)
            {
                case TypeParameterDeclaration.Type(_):
                    var result = StringArrayTreeToCode.toTypeReference(value, context);
                    result.map(CodeTypeArgumentElement.Type);
                    
                case TypeParameterDeclaration.Value(_):
                    var result = StringArrayTreeToCode.toValue(value, context);
                    result.map(CodeTypeArgumentElement.Value);
            }
        }

        return switch (attribute.data.rule)
        {
            case Option.None:
                switch (readElement())
                {
                    case Option.Some(value):
                        CodeTypeArgument.Required(convert(value));
                        
                    case Option.None:
                        context.addError(
                            IdlModuleErrorKind.NotEnoughTypeArgument, 
                            attribute.tag
                        );
                        CodeTypeArgument.Required(WithTag.empty(tag));
                }

            case Option.Some(rule):
                switch (rule.data)
                {
                    case VarRule.Default(defaultValue):
                        switch (readElement())
                        {
                            case Option.Some(value):
                                CodeTypeArgument.Required(convert(value));
                                
                            case Option.None:
                                CodeTypeArgument.Required(convert(defaultValue._0));
                        }
                        
                    case VarRule.Optional:
                        switch (readElement())
                        {
                            case Option.Some(value):
                                CodeTypeArgument.Optional(
                                    Option.Some(convert(value))
                                );
                                
                            case Option.None:
                                CodeTypeArgument.Optional(Option.None);
                        }
                
                    case VarRule.Repeated:
                        var array = [];
                        while (true)
                        {
                            switch (readElement())
                            {
                                case Option.Some(value):
                                    array.push(convert(value));
                                    
                                case Option.None:
                                    break;
                            }
                        }
                        CodeTypeArgument.Repeated(array);
                }
        }
    }
    
    private function readElement():Option<WithTag<StringArrayTree>> 
    {
        if (arguments.length <= index)
        {
            Option.None;
        }
        
        return Option.Some(arguments[index++]);
    }
}