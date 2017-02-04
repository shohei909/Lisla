package litll.idl.generator.output.data.store;
import litll.idl.generator.output.data.store.HaxeDataClassInterface;
import litll.idl.std.data.idl.TypeDefinition;

class HaxeDataInterfaceKindTools 
{
    public static function createDefault(type:TypeDefinition):HaxeDataInterfaceKind
    {
        return switch (type)
        {
            case TypeDefinition.Newtype(_) | TypeDefinition.Struct(_) | TypeDefinition.Tuple(_):
                HaxeDataInterfaceKind.Class(
                    new HaxeDataClassInterface(
                        HaxeDataConstructorKind.New
                    )
                );
                
            case TypeDefinition.Enum(_):
                HaxeDataInterfaceKind.Enum(
                    new HaxeDataEnumInterface()
                );
        }
    }
}
