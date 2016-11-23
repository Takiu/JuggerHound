package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import states.PlayState;
import flixel.system.FlxSound;

/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class GameOverState extends FlxState
{	
	
	private var gameOver:FlxText;	
	private var _victory:Bool;
	private var replayText:FlxText;
	private var optionPointer:FlxSprite;
	private var titan:FlxSprite;
	
	public function new(victory:Bool) 
	{
		_victory = victory;
		super();
	}
	
	override public function create():Void
	{
		super.create();

		gameOver = new FlxText(20, 50, 0, null, 20);
		
		titan = new FlxSprite();
		
		if (_victory)
		{
			gameOver.text = "¡¡VICTORY!!";
			titan.loadGraphic(AssetPaths.Titan__png, true, 34, 34);
			titan.animation.add("jump", [11], 4);
			titan.animation.play("jump");
		}
		gameOver.alignment = CENTER;
		gameOver.screenCenter(X);
		gameOver.color = 0xFFc300ff;
		
		add(gameOver);
		
		titan.x = (FlxG.width / 2) - titan.width / 2 ;
		titan.y = 120;
		add(titan);
		
		replayText = new FlxText(0, 0, "REPLAY");
		replayText.x = (FlxG.width / 2) - (replayText.width / 2);
		replayText.y = FlxG.height - replayText.height - 10;
		add(replayText);
		
		optionPointer = new FlxSprite();
		optionPointer.loadGraphic(AssetPaths.Dog__png, true, 36, 16);
		optionPointer.animation.add("Anim", [0, 1], 20, true);
		optionPointer.animation.play("Anim");
		optionPointer.flipX = true;
		optionPointer.x = replayText.x - optionPointer.width - 5;
		optionPointer.y = replayText.y - 1;
		add(optionPointer);
	}
	
	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			Restart();
		}
		super.update(elapsed);
	}
	
	private function Restart():Void
	{
		FlxG.switchState(new PlayState());
	}
}