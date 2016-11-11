package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import sprites.Disparo;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
import states.MenuState;

class Boss extends Enemies 
{

	private static inline var sbX: Int = 2150;
	private static inline var sbY: Int = 915;
	private var atacando : Bool = false;
	public var tierraE:FlxTypedGroup<Disparo>;
	public var techoE:FlxTypedGroup<Disparo>;
	public var piedra:FlxTypedGroup<Disparo>;
	private var tipoA : Int;
	private var r : FlxRandom;
	private var lado : Bool = false;
	private var cont : Int=0;
	private var timeAtt: Int = 0;
	private var _tween:FlxTween;
	private var posPlayer : Float;
	public var vida : Int = 20000;
	public var hpBar:FlxBar;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.Lars2__png, true, 38, 38);
		animation.add("idle", [0,1], 2);
		animation.add("walk", [2, 3,4,5], 6);
		this.x = sbX;
		this.y = sbY;
		this.acceleration.y = 700;
		tierraE = new FlxTypedGroup<Disparo>();
		techoE = new FlxTypedGroup<Disparo>();
		piedra = new FlxTypedGroup<Disparo>();
		
		hpBar = new FlxBar(1985, 650,BOTTOM_TO_TOP, 8, 100);
		hpBar.createFilledBar(0xFF8e0000, 0xFFFF0000);
		hpBar.setRange(0, vida);
		hpBar.value = vida;
		
		r = new FlxRandom();
		r.resetInitialSeed();
		for (i in 0...14){
			var disp = new Disparo( 1960 + (i * 16), 930);
			disp.kill;			
			disp.loadGraphic(AssetPaths.Ata1__png, true, 16, 32);
			disp.animation.add("Start", [11], 30, false);
			disp.animation.add("Ata1Eleva", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 11], 25, false);
			disp.animation.play("Start");
			tierraE.add(disp);
			FlxG.state.add(disp);
		}
		for (i in 0...7){
			var disp = new Disparo(1960 + (i * 32), 782);
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
		//FlxG.watch.add(Boss, "vida");
	}
	
	public function Atacar()
	{		
		if (!atacando)
		{
			animation.play("idle");
			atacando = true;
			tipoA = 1;//r.int(1, 3);
			velocity.x = 0;			
			if (lado)
			{
				cont = Math.round((2167 - (this.x + 16)) / 16);
				cont = 13 - cont;
			}
			else
			{
				cont = Math.round((this.x - 1960) / 16) ;
			}
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
	
	public function MovAttBoss(playerX : Float)
	{
		posPlayer = playerX;
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
			flipX = false;
			animation.play("walk");
		}
		else
		{
			velocity.x = -50;
			flipX = true;
			animation.play("walk");
		}
		lado = (this.x <= posPlayer)?true:( this.x >= posPlayer)?false:lado;
		if ((posPlayer + 35 >= this.x && !lado) || (posPlayer <= this.x + 40 && lado))
		{
			animation.play("idle");
			velocity.x = 0;		
		}
	}
	
	private function Ata1()
	{
		if (atacando)		
		{	
			if (!lado)
				cont--;
			else	
				cont++;			
			if (cont <= -1 || cont >= 14)
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
				pr = r.int(0, 6);
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
		if (timePico == 17) {
			techoE.forEach(function(obj : Disparo)
			{
				if (obj.activado)
				{			
					obj.animation.play("Nace");
					obj.activado = false;
					obj.velocity.y = 0; 
					obj.y = 782;
					obj.colision = false;
				}
			});
			atacando = false;
			timePico = 0;
		}
	}
	
	var posPA : Float;
	var xs : Array<Float>;
	var ys : Array<Float>;
	private function Ata3()
	{
		if (timePico == 0)		
		{	
			posPA = posPlayer;
			piedra.members[0].revive();
			if (lado)
			{
				xs = [this.x+19, this.x + (posPA - this.x)/2, posPA];
				ys = [this.y+19, this.y - 96, this.y + 6];
			}
			else
			{				
				xs = [this.x-19, this.x + (this.x - posPlayer )/2, posPA];
				ys = [this.y+19, this.y - 96, this.y + 6];
			}			
			piedra.members[0].x = xs[0];
			piedra.members[0].y = ys[0];
		}
		timePico++;
		if (timePico == 5)
		{
			_tween = FlxTween.quadMotion(piedra.members[0],xs[0],ys[0],xs[1],ys[1],xs[2],ys[2],1,true);
		}
		if (timePico > 15)
		{
			if ((piedra.members[0].x >= posPA && !lado) || (piedra.members[0].x <= posPA && lado))
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
				obj.colision = false;
			});
			timePico = 0;
		}	
		
	}
	
	public function Colisiones(player : FlxSprite)
	{
		//Colision con la tierra
		tierraE.forEach(function(obj : Disparo)
		{			
			if (FlxG.pixelPerfectOverlap(player, obj, null) && !obj.colision)
			{
				obj.colision = true;
			}
		});
		
		//Colision con los picos
		techoE.forEach(function(obj : Disparo)
		{
			if (obj.activado)
			{			
				if (FlxG.pixelPerfectOverlap(player, obj, null) && !obj.colision)
				{
					obj.colision = true;
				}
			}
		});
		
		//Colision con la piedra		
		if (FlxG.pixelPerfectOverlap(player, piedra.members[0], null) && !piedra.members[0].colision)
		{
			piedra.members[0].colision = true;
		}
		
		//Colision con el boss
		if (FlxG.overlap(this, player))
		{
			
		}
	}
	
	public function Danio()
	{
		vida -= 200;
		hpBar.value = vida;
		if (vida <= 3000)
		if (vida <= 0)
		{
			//Perdio
			destroy();
			FlxG.switchState(new MenuState());
		}
		
	}
	
}