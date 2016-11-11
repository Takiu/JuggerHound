package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import sprites.Player;
import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import sprites.Boss;
import sprites.Disparo;
import sprites.Dog;

class PlayState extends FlxState
{
	private var player:Player;
	public var background:FlxTilemap;
	public var tiles:FlxTilemap;
	public var otherTiles:FlxTilemap;
	public var otherTiles2:FlxTilemap;
	public var otherTiles3:FlxTilemap;
	public var cameraGuide:FlxSprite;
	public var stair:FlxSprite;
	public var box:FlxSprite;
	private var boss : Boss;
	public var playerDisparos:FlxTypedGroup<Disparo>;
	public var dog:Dog;
	
	override public function create():Void
	{
		super.create();
		
		//TODA LA CREACION DEL NIVEL Y MAPA
		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.JuggerLevel__oel);
		//background = loader.loadTilemap(AssetPaths.tile_ref__png, 16, 32, "Background");
		
		tiles = loader.loadTilemap(AssetPaths.tile_ref__png, 16, 16, "floor");
		otherTiles = loader.loadTilemap(AssetPaths.stairs__png, 16, 16, "stairs");
		otherTiles2 = loader.loadTilemap(AssetPaths.TemplateB__png, 16, 16, "Capa2");
		otherTiles3 = loader.loadTilemap(AssetPaths.TemplateA__png, 16, 16, "Capa1");
		Reg.stairs = new FlxTypedGroup<FlxSprite>();
		loader.loadEntities(addEntities, "entities");
		
		//SETEAR LAS PROPIEDADES DE LAS COLISIONES
		tiles.setTileProperties(0, FlxObject.NONE);
		otherTiles2.setTileProperties(0, FlxObject.NONE);
		
		//LAS REGLAS A LA CAMARA SOBRE DONDE PUEDE MOVERSE
		FlxG.camera.setScrollBounds(0, 980*4, 0, 980);
		FlxG.worldBounds.set(0,0,980*4,980);
		
		cameraGuide = new FlxSprite(FlxG.camera.width / 2, FlxG.camera.height / 2);
		//POSICION DEL CAMERA GUIDE PARA ESTAR CERCA DEL BOSS
		cameraGuide.makeGraphic(1, 1, 0x00000000);
		FlxG.camera.follow(cameraGuide);
		
		//add(background);
		
		add(cameraGuide);
		dog = new Dog(player.x + 300,player.y - 150);
		//add(dog);
		
		//add Boss
		boss = new Boss();
		boss.kill();
		add(boss);
		//FlxG.watch.add(player, "x");
		//FlxG.watch.add(boss, "y");
		
	}
	
	var Bosstime : Int = 0;
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(tiles, player);
		FlxG.collide(dog,tiles);
		FlxG.collide(tiles, boss);
		FlxG.overlap(boss, player,null,Colisiones);
		FlxG.overlap(boss, playerDisparos, null, Colisiones);
		FlxG.overlap(dog, playerDisparos, null, Colisiones);
		trace(player.x + "----" + player.y);
		if (Reg.bossFight){
			FlxG.collide(player, otherTiles);
		}
		if ((cameraGuide.x >= 1989 && cameraGuide.x <= 2072) && cameraGuide.y == 935){
			Reg.bossFight = true;
			Reg.bossFightBegins = true;
		}
		
		if (!Reg.bossFightBegins){
			player.playerMovement();
			if (!Reg.bossFight){
				cameraGuide.x = player.x;
				cameraGuide.y = player.y;
			}
		} else {
			if (cameraGuide.x <= 2072){
				cameraGuide.x++;
				player.velocity.x = 0;
				player.velocity.y = 0;
			} else {
				Reg.bossFightBegins = false;
				boss.revive();				
			}
		}
		
		if (boss.alive)
		{
			if (Bosstime >= 300)
			{
				boss.Atacar();
				Bosstime = 0;
			}
			else{
				boss.MovAttBoss(player.x);
				boss.Colisiones(player);
			}
			Bosstime++;	
		}
		
		Reg.playerXPosition = player.x;
		Reg.jumping += elapsed;
	}
	
	private function addEntities(entityName:String, entityData:Xml):Void
	{
		
		if (entityName == "doblestairs")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
				
			stair = new FlxSprite(X, Y);
			stair.loadGraphic(AssetPaths.escaleraDoblev1__png, true, 32, 16);
			Reg.stairs.add(stair);
		
		}
		/*if (entityName == "box"){
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			box = new FlxSprite(X, Y);
			box.loadGraphic(AssetPaths.caja__png, true, 16, 16);
			Reg.boxes.add(box);
		}*/
		if (entityName == "player"){
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));	
			
			playerDisparos = new FlxTypedGroup<Disparo>();		
			add(playerDisparos);
			//player = new Player(X, Y, playerDisparos);
			player = new Player(1400,900, playerDisparos);
		}
		add(tiles);
		add(otherTiles);
		add(otherTiles3);
		add(otherTiles2);
		add(Reg.stairs);
		add(player);
		//add(Reg.boxes);
		//player.x = 1200;
	}
	
	private function Colisiones(Sprite1:FlxObject, Sprite2:FlxObject): Bool{		
		var sName1:String = Type.getClassName(Type.getClass(Sprite1));
		var sName2:String = Type.getClassName(Type.getClass(Sprite2));
		
		if (sName1 == "sprites.Boss" && sName2 == "sprites.Player")
		{
			//Restar vida player
			if (player.x >= boss.x)
				player.x += 5;
			if (player.x <= boss.x)
				player.x -= 5;					
			return true;
		}
		
		if (sName1 == "sprites.Boss" && sName2 == "sprites.Disparo")
		{
			//Restar vida boss
			boss.Danio();
			var disp: Dynamic = cast(Sprite2, Disparo);
			disp.kill();
			disp.activado = false;
			return true;
		}
		
		if (sName1 == "sprites.Dog" && sName2 == "sprites.Disparo"){
			var disp: Dynamic = cast(Sprite2, Disparo);
			disp.kill();
			disp.activado = false;
			
			var _dog: Dynamic = cast(Sprite1, Dog);
			_dog.kill();
			return true;
		}
		return false;
	}
	
}

