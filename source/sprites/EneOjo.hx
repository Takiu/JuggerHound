package sprites;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class EneOjo extends Enemies
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.Eyev1__png, true, 16, 16);
		animation.add("Anim", [0,1, 2, 3, 4, 5, 6, 7], 20, true);
		animation.play("Anim");
	}
	
	var time : Int = 0;
	private var dis : Int;
	
	public function Movimiento(pla : FlxSprite):Void 
	{			
		dis = Math.round(Math.sqrt(Math.pow(this.x + 8 - pla.x, 2) + Math.pow(this.y + 8 - pla.y - 17, 2)));
		if (dis < 100)	
		{
			time = 0;
			if (this.x >= pla.x && this.y <= pla.y)
			{
				this.x -= 0.5;
				this.y += 0.5;
			}
			else if (this.x <= pla.x && this.y <= pla.y)
			{
				this.x += 0.5;
				this.y += 0.5;
			}
			else if (this.x >= pla.x && this.y >= pla.y)
			{
				this.x -= 0.5;
				this.y -= 0.5;
			}
			else if (this.x <= pla.x && this.y >= pla.y)
			{
				this.x += 0.5;
				this.y -= 0.5;
			}
			if (this.x > pla.x){
				flipX = false;
			}
			if (this.x < pla.x){
				flipX = true;
			}
			FlxG.overlap(this, pla,null,Colisiones);
		}
		else
		{
			if (flipX)
			{
				x++;
			}
			else
			{
				x--;
			}
			if (time == 40)
			{
				time = 0;
				flipX = (flipX)?false:true;
			}
		}
		time++;
	}
	
	private function Colisiones(sp1:FlxObject, sp2:Player): Bool		
	{
		this.kill();
		sp2.vida--;
		return true;
	}
	
}