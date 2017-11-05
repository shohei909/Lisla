package lisla.type.lisla.type;

enum TypeReference 
{
    Primitive(value:TypePath);
    Generic(value:GenericTypeReference);
}