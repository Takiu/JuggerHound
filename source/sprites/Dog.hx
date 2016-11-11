package sprites;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class Dog extends Enemies
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.Dog__png, true, 36, 16);
		animation.add("Anim", [0, 1], 20, true);
		animation.play("Anim");
		acceleration.y = 1000;
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (x < Reg.playerXPosition){
			velocity.x += 10;
			flipX = true;
		} else {
			velocity.x -= 10;
			flipX = false;
		}
	}
}