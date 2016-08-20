package sora.idl.std.data.core;

enum SoraOption<T>
{
	Some(data:SoraSingle<T>);
	None(unit:Unit);
}
