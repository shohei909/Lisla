package lisla.type.core;
import lisla.data.meta.core.WithTag;

class Tuple0 {
    public function new() {}
}

class Tuple1<T0> {
    public var _0:WithTag<T0>;
    public function new(_0:WithTag<T0>) {
        this._0 = _0;
    }
}

class Tuple2<T0, T1> {
    public var _0:WithTag<T0>;
    public var _1:WithTag<T1>;
    public function new(_0:WithTag<T0>, _1:WithTag<T1>) {
        this._0 = _0;
        this._1 = _1;
    }
}
