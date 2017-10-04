// This file is generated by hxarraytree.
package arraytree.idl.hxarraytree.arraytree2entity;
class EntityToArrayTreeDeclarationArrayTreeToEntity {
    public static function process(context:arraytree.idl.arraytree2entity.ArrayTreeToEntityContext):hxext.ds.Result<arraytree.idl.hxarraytree.entity.EntityToArrayTreeDeclaration, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>> {
        return switch (context.arraytree.kind) {
            case arraytree.data.tree.al.AlTreeKind.Leaf(_):{
                hxext.ds.Result.Error(arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError.ofArrayTree(context.arraytree, arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind.CantBeString));
            };
            case arraytree.data.tree.al.AlTreeKind.Arr(array):{
                var arrayContext = new arraytree.idl.arraytree2entity.ArrayTreeToEntityArrayContext(array, 0, context.config);
                var instance = {
                    arrayContext.readLabel("entity_to_arraytree");
                    var arg0 = switch (arrayContext.readFixedInline(arraytree.idl.hxarraytree.arraytree2entity.EntityToArrayTreeConfigArrayTreeToEntity.process, arrayContext.length - 0)) {
                        case hxext.ds.Result.Ok(data):{
                            data;
                        };
                        case hxext.ds.Result.Error(data):{
                            return hxext.ds.Result.Error(data);
                        };
                    };
                    var instance = new arraytree.idl.hxarraytree.entity.EntityToArrayTreeDeclaration(arg0);
                    hxext.ds.Result.Ok(instance);
                };
                switch (arrayContext.closeOrError()) {
                    case haxe.ds.Option.None:{
                        instance;
                    };
                    case haxe.ds.Option.Some(data):{
                        hxext.ds.Result.Error(data);
                    };
                };
            };
        };
    }
    public static function variableInlineProcess(arrayContext:arraytree.idl.arraytree2entity.ArrayTreeToEntityArrayContext):hxext.ds.Result<arraytree.idl.hxarraytree.entity.EntityToArrayTreeDeclaration, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>> return null;
}