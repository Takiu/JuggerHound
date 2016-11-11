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
		makeGraphic(20, 20);
		acceleration.y = 1000;
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (x < Reg.playerXPosition){
			velocity.x += 10;
		} else {
			velocity.x -= 10;
		}
	}
}