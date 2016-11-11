package sprites;

import flixel.system.FlxAssets.FlxGraphicAsset;
import sprites.Disparo;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxObject;

/**
 * ...
 * @author ...
 */
class EnePlanta extends Enemies
{

	public var disparos:FlxTypedGroup<Disparo>;
	private static var xs : Float = 0;
	private static var ys : Float=0;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.eggv1__png, true, 30, 30);
		animation.add("Abrir", [0, 1, 2, 3], 2, false);
		animation.add("Quieto", [2, 3], 10, true);
		animation.add("Cerrar", [3,2,1,0], 2, false);
		animation.add("Start", [0], 30, false);
		animation.play("Start");
		disparos =  new FlxTypedGroup<Disparo>();
		for (i in 0...5){
			var disp = new Disparo(this.x + 15, this.y + 15);
			disp.makeGraphic(5, 5, 0xFF005512);			
			disp.kill();
			disparos.add(disp);
			FlxG.state.add(disp);
		}
	}
	var time : Int = 0;
	
	public function Movimiento(pla : Player):Void 
	{
		xs = this.x;
		ys = this.y;
		switch(time)
		{
			case 40: 
				animation.play("Abrir");
			case 80:
				animation.play("Quieto");
				Atacar();
			case 300:
				animation.play("Cerrar");
				Destruir();
				time = 0;
		}		
		time++;
		//Revisa si fue dañado
		FlxG.overlap(disparos, pla,null,Colisiones);
	}		
	
	private function Colisiones(sp1:FlxObject, sp2:Player): Bool		
	{
		sp1.kill();
		sp2.vida--;
		return true;
	}
	
	private function Atacar()
	{
		disparos.forEach(function(obj : Disparo)
		{
			obj.x = this.x + 15;
			obj.y = this.y + 15;
			obj.revive();
		});
		disparos.members[0].velocity.x = -100;
		disparos.members[1].velocity.x = -100;
		disparos.members[1].velocity.y = 100;
		disparos.members[2].velocity.y = 100;
		disparos.members[3].velocity.x = 100;
		disparos.members[3].velocity.y = 100;
		disparos.members[4].velocity.x = 100;
	}
	
	public function Destruir()
	{
		disparos.forEach(function(obj : Disparo)
		{			
			obj.kill();
		});
	}
	
}