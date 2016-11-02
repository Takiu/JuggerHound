package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;

/**
 * ...
 * @author Sebastian Sforzini
 */
class Player extends FlxSprite
{
	//private var player:FlxSprite;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.Titan__png, true, 34, 34);
		acceleration.y = 700;
		animation.add("idle", [0,1], 2);
		animation.add("walk", [2, 3,4,5], 8);
		animation.add("jump", [11], 4);
		animation.add("fall", [11], 4);
		animation.add("moving_shoot", [7,8,9,10], 8);
		//player.scale.set(2, 2);
		setSize(25, 25);
		centerOffsets();
	}
	
	override public function update(elapsed:Float):Void
	{
		
	}
	
	
}