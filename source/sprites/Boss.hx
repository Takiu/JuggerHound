package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import sprites.Disparo;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.math.FlxRandom;

class Boss extends Enemies 
{

	private static inline var sbX: Int = 230;
	private static inline var sbY: Int = 100;
	private var atacando : Bool = false;
	public var tierraE:FlxTypedGroup<Disparo>;
	private var tipoA : Int;
	private var r : FlxRandom;
	private var lado : Bool = false;
	private var cont : Int=0;
	private var timeAtt: Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(32, 32, 0xFFFF00FF);
		this.x = sbX;
		this.y = sbY;
		tierraE = new FlxTypedGroup<Disparo>();
		r = new FlxRandom();
		r.resetInitialSeed();
		for (i in 0...16){
			var disp = new Disparo(i * 16, this.y);
			disp.kill;			
			disp.loadGraphic(AssetPaths.Ata1__png, true, 16, 32);
			disp.animation.add("Start", [11], 30, false);
			disp.animation.add("Ata1Eleva", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 11], 25, false);
			disp.animation.play("Start");
			tierraE.add(disp);
			FlxG.state.add(disp);
		}
	}
	
	public function Atacar()
	{		
		if (!atacando)
		{
			atacando = true;
			tipoA = 1;//r.int(1, 4);
			velocity.x = 0;			
			if(lado)
				cont = Math.round((this.x + 16) / 16);			
			else
				cont = Math.round(this.x / 16) ;			
		}
		switch(tipoA)
		{
			case 1:
				Ata1();
			case 2:
				Ata2();
			case 3:
				Ata3();
			case 4:
				Ata4();
		}
	}
	
	public function MovAttBoss()
	{
		if (atacando)
		{
			if (timeAtt >= 10)
			{
				Atacar();
				timeAtt = 0;
			}
			timeAtt++;
		}
		else
		{
			Mover();
		}
	}
	
	private function Mover()
	{
		if (lado)
		{
			velocity.x = 50;
		}
		else
		{
			velocity.x = -50;
		}
		lado = (this.x <= 0)?true:( this.x >= 224)?false:lado;
	}
	
	private function Ata1()
	{
		if (atacando)		
		{	
			if (!lado)
				cont--;
			else	
				cont++;			
			if (cont <= -1 || cont >= 15)
			{
				DestruirTierra();
			}
			else{
				tierraE.members[cont].revive();
				tierraE.members[cont].animation.play("Ata1Eleva");
			}
		}
	}
	
	private function Ata2()
	{
		
	}
	
	private function Ata3()
	{
		
	}
	
	private function Ata4()
	{
		
	}
	
	var timeTierra : Int = 0;
	private function DestruirTierra()
	{	
		timeTierra++;
		if (timeTierra == 6)
		{
			atacando = false;
			tierraE.forEachAlive(function(obj : Disparo)
			{
				obj.kill();
			});
			timeTierra = 0;
		}	
		
	}
	
}