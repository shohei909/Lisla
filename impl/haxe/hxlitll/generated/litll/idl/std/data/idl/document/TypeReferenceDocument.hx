// This file is generated by hxlitll.
package litll.idl.std.data.idl.document;
class TypeReferenceDocument {
    public var completion : haxe.ds.Option<hxext.ds.Maybe<litll.core.tag.ArrayTag>>;
    public var completionConst : Array<litll.core.Litll>;
    public var completionType : Array<litll.idl.std.data.idl.TypeReference>;
    public function new(completion:haxe.ds.Option<hxext.ds.Maybe<litll.core.tag.ArrayTag>>, completionConst:Array<litll.core.Litll>, completionType:Array<litll.idl.std.data.idl.TypeReference>) {
        this.completion = completion;
        this.completionConst = completionConst;
        this.completionType = completionType;
    }
}