package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import sprites.Disparo;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;

class Boss extends Enemies 
{

	private static inline var sbX: Int = 0;
	private static inline var sbY: Int = 100;
	private var atacando : Bool = false;
	private var tierraE:FlxTypedGroup<Disparo>;
	private var techoE:FlxTypedGroup<Disparo>;
	private var piedra:FlxTypedGroup<Disparo>;
	private var tipoA : Int;
	private var r : FlxRandom;
	private var lado : Bool = false;
	private var cont : Int=0;
	private var timeAtt: Int = 0;
	private var _tween:FlxTween;
	private var _min:FlxPoint;
	private var _max:FlxPoint;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(32, 32, 0xFFFF00FF);
		this.x = sbX;
		this.y = sbY;		
		tierraE = new FlxTypedGroup<Disparo>();
		techoE = new FlxTypedGroup<Disparo>();
		piedra = new FlxTypedGroup<Disparo>();
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
		for (i in 0...8){
			var disp = new Disparo(i * 32, 0);
			disp.loadGraphic(AssetPaths.Ata2__png, true, 32, 32);
			disp.animation.add("Start", [2],30,false);
			disp.animation.add("Terre", [1, 2, 3, 2], 30, true);
			disp.animation.add("Nace", [14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 2], 20, false);
			disp.animation.play("Start");
			techoE.add(disp);
			FlxG.state.add(disp);
		}
		var pied = new Disparo(0,0);
		pied.makeGraphic(32, 32, 0xFFA4A4A4);
		pied.kill();
		piedra.add(pied);
		FlxG.state.add(pied);
		//FlxG.watch.add(Boss, "condi");
	}
	
	public function Atacar()
	{		
		if (!atacando)
		{
			atacando = true;
			tipoA = r.int(1, 3);
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
	
	
	var timePico : Int = 0;	
	
	private function Ata2()
	{
		if (timePico == 0) {
			var pr : Int = 0;
			for (i in 0...3) {
				pr = r.int(0, 7);
				techoE.members[pr].activado = true;
				techoE.members[pr].animation.play("Terre");
			}		
		}
		if (timePico == 9)
		{	
			techoE.forEach(function(obj : Disparo)
			{
				if (obj.activado)
				{			
					obj.animation.stop();
					obj.velocity.y = 200; 
				}
			});
		}				
		timePico++;
		if (timePico == 15) {
			techoE.forEach(function(obj : Disparo)
			{
				if (obj.activado)
				{			
					obj.animation.play("Nace");
					obj.activado = false;
					obj.velocity.y = 0; 
					obj.y = 0;
				}
			});
			atacando = false;
			timePico = 0;
		}
	}
	
	var posPlayer : Float;
	var xs : Array<Float>;
	var ys : Array<Float>;
	private function Ata3()
	{
		if (timePico == 0)		
		{	
			//posPlayer = Posicion del player;
			piedra.members[0].revive();
			if (lado)
			{
				posPlayer = 240;
				xs = [this.x+16, this.x + (240 - this.x)/2, 240];
				ys = [this.y+16, this.y - 96, 100];
			}
			else
			{				
				posPlayer = 0;
				xs = [this.x-16, this.x/2, 0];
				ys = [this.y+16, this.y - 96, 100];
			}			
			piedra.members[0].x = xs[0];
			piedra.members[0].y = ys[0];
		}
		timePico++;
		if (timePico == 10)
		{
			_tween = FlxTween.quadMotion(piedra.members[0],xs[0],ys[0],xs[1],ys[1],xs[2],ys[2],1,true);
		}
		if (timePico > 15)
		{
			if ((piedra.members[0].x >= posPlayer && !lado) || (piedra.members[0].x <= posPlayer && lado))
			{			
				if (lado)
				{
					piedra.members[0].x++;
				}
				else
				{
					piedra.members[0].x--;
				}
			}
			else
			{			
				atacando = false;
				timePico = 0;
				piedra.members[0].kill();
			}
		}
		
	}
	
	private function Ata4()
	{
		
	}
	
	private function DestruirTierra()
	{	
		timePico++;
		if (timePico == 6)
		{
			atacando = false;
			tierraE.forEachAlive(function(obj : Disparo)
			{
				obj.kill();
			});
			timePico = 0;
		}	
		
	}
	
}