package litll.idl.generator.output.entity.store;
import litll.idl.generator.output.entity.store.HaxeEntityClassInterface;
import litll.idl.std.data.idl.TypeDefinition;

class HaxeEntityInterfaceKindTools 
{
    public static function createDefault(type:TypeDefinition):HaxeEntityInterfaceKind
    {
        return switch (type)
        {
            case TypeDefinition.Newtype(_) | TypeDefinition.Struct(_) | TypeDefinition.Tuple(_):
                HaxeEntityInterfaceKind.Class(
                    new HaxeEntityClassInterface(
                        HaxeEntityConstructorKind.New
                    )
                );
                
            case TypeDefinition.Enum(_):
                HaxeEntityInterfaceKind.Enum(
                    new HaxeEntityEnumInterface()
                );
        }
    }
}
