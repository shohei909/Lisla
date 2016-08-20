package sora.idl.std.data.idl;

enum TypeReference 
{
	Primitive(primitive:TypePath);
	Generic(generic:GenericTypeReference);
}