package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import states.MenuState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(256, 240, states.MenuState, 2));
	}
}
