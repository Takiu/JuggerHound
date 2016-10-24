package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.FlxObject;

class MenuState extends FlxState
{
	private var NameTxt:FlxText;
	private var playText:FlxText;
	private var optionPointer:FlxSprite;
	
	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		super.create();
		NameTxt = new FlxText(20, 50, 0, "JugguerHound", 29);
		NameTxt.alignment = CENTER;
		NameTxt.screenCenter(X);
		NameTxt.color = 0xFFc300ff;
		add(NameTxt);
		
		playText = new FlxText(0, 0, "PLAY");
		playText.x = (FlxG.width / 2) - (playText.width / 2);
		playText.y = FlxG.height - playText.height - 10;
		add(playText);
		
		optionPointer = new FlxSprite();
		optionPointer.makeGraphic(16,6,0xFFFFFF00);
		optionPointer.x = playText.x - optionPointer.width - 5;
		optionPointer.y = playText.y - 1;
		add(optionPointer);
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			Start();
		}
		super.update(elapsed);
	}
	
	public function Start():Void
	{
		remove(NameTxt);
		FlxG.switchState(new PlayState());
	}
}
