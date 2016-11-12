package sprites;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;
import flixel.FlxObject;

/**
 * ...
 * @author ...
 */
class EneSaltin extends Enemies
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.Saltin__png, true, 16, 36);
		animation.add("Anim", [2, 1, 0, 1], 5, true);
		animation.play("Anim");
		acceleration.y = 700;		
	}
	var time : Int = 0;
	var posy : Float = 0;
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);		
		
		if (time == 30){posy = this.y; time = -1; }
		if (this.y <= posy - 30)
		{
			acceleration.y = 700;
		}
		if(Math.round(this.y) == Math.round(posy)){			
			acceleration.y = 0;
			velocity.y = -100;				
		}
		if(time != -1)
			time++;
	}
	
}