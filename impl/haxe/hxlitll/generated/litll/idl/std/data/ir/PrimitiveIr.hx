// This file is generated by hxlitll.
package litll.idl.std.data.ir;
enum PrimitiveIr {
    FixedInt(size:litll.idl.std.data.core.LitllUInt64, data:litll.idl.std.data.core.BigInt);
    FixedUint(size:litll.idl.std.data.core.LitllUInt64, data:litll.idl.std.data.core.BigUInt);
    VariableInt(data:litll.idl.std.data.core.BigInt);
    VariableUint(data:litll.idl.std.data.core.BigUInt);
    Float64(data:litll.idl.std.data.core.LitllFloat64);
    Boolean(data:litll.idl.std.data.core.LitllBoolean);
    String(data:litll.core.LitllString);
    Binary(data:litll.idl.std.data.core.Binary);
}