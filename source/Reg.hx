package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class Reg 
{

	//Variables globales y constantes
	
	inline static public var hSpeed:Float = 250;
	inline static public var vSpeed:Float = 300;
	inline static public var maxJumpTime:Float = 0.5;
	static public var jumping:Float = 0;
	static public var stairs:FlxTypedGroup<FlxSprite>;
	
}