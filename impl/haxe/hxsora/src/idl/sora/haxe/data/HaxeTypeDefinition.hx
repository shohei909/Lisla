package sora.haxe.data;
import sora.haxe.data.HaxeClassDefinition;

enum HaxeTypeDefinition
{
	ClassType(detail:HaxeClassDefinition);
	EnumType(detail:HaxeEnumDefinition);
	AbstractType(detail:AbstractDefinition);
}
