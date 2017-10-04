// This file is generated by hxarraytree.
package arraytree.idl.hxarraytree.arraytree2entity;
class EntityToBislaConfigArrayTreeToEntity {
    public static function process(context:arraytree.idl.arraytree2entity.ArrayTreeToEntityContext):hxext.ds.Result<arraytree.idl.hxarraytree.entity.EntityToBislaConfig, Array<arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError>> return switch (context.arraytree.kind) {
        case arraytree.data.tree.al.AlTreeKind.Leaf(_):{
            hxext.ds.Result.Error(arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError.ofArrayTree(context.arraytree, arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind.CantBeString));
        };
        case arraytree.data.tree.al.AlTreeKind.Arr(array):{
            {
                var arg0 = haxe.ds.Option.None;
                var arg1 = [];
                for (arraytreeData in array) {
                    var context = new arraytree.idl.arraytree2entity.ArrayTreeToEntityContext(arraytreeData, context.config);
                    switch arraytreeData.kind {
                        case arraytree.data.tree.al.AlTreeKind.Arr(array) if (1 <= array.length && array[0].kind.match(arraytree.data.tree.al.AlTreeKind.Leaf(_ => "filter"))):arg1.push(switch (arraytree.idl.hxarraytree.arraytree2entity.FilterDeclarationArrayTreeToEntity.process(context)) {
                            case hxext.ds.Result.Ok(data):{
                                data;
                            };
                            case hxext.ds.Result.Error(data):{
                                return hxext.ds.Result.Error(data);
                            };
                        });
                        case arraytreeData:return hxext.ds.Result.Error(arraytree.idl.arraytree2entity.error.ArrayTreeToEntityError.ofArrayTree(arraytreeData, arraytree.idl.arraytree2entity.error.ArrayTreeToEntityErrorKind.UnmatchedStructElement(["no_output", "filter"])));
                    };
                };
                var instance = new arraytree.idl.hxarraytree.entity.EntityToBislaConfig(arg0, arg1);
                hxext.ds.Result.Ok(instance);
            };
        };
    };
}