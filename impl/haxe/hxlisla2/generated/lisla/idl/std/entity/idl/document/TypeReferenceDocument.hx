// This file is generated by hxarraytree.
package arraytree.idl.std.entity.idl.document;
class TypeReferenceDocument {
    public var completion : haxe.ds.Option<hxext.ds.Maybe<arraytree.data.meta.core.Metadata>>;
    public var completionConst : Array<arraytree.data.tree.al.AlTree>;
    public var completionType : Array<arraytree.idl.std.entity.idl.TypeReference>;
    public function new(completion:haxe.ds.Option<hxext.ds.Maybe<arraytree.data.meta.core.Metadata>>, completionConst:Array<arraytree.data.tree.al.AlTree>, completionType:Array<arraytree.idl.std.entity.idl.TypeReference>) {
        this.completion = completion;
        this.completionConst = completionConst;
        this.completionType = completionType;
    }
}