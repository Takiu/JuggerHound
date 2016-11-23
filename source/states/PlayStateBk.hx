package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import sprites.Enemies;
import sprites.Player;
import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import sprites.Boss;
import sprites.Disparo;
import sprites.Dog;
import flixel.system.FlxSound;
import sprites.EneSaltin;
import sprites.EnePlanta;
import sprites.EneOjo;
import flixel.math.FlxRandom;
import sprites.Botiquin;

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
	public var boxes:FlxTypedGroup<FlxSprite>;
	public var playerDisparos:FlxTypedGroup<Disparo>;
	public var dog:Dog;
	public var xSaltinPos = new Array();
	public var ySaltinPos = new Array();
	public var enemyOne:FlxTypedGroup<EneSaltin>;
	public var enemyTwo:FlxTypedGroup<Dog>;
	public var enemyThird:FlxTypedGroup<EnePlanta>;
	public var enemyFour:FlxTypedGroup<EneOjo>;
	private var music:FlxSound;
	private var botiquin : FlxTypedGroup<Botiquin>;
	
	override public function create():Void
	{
		super.create();
		
		//TODA LA CREACION DEL NIVEL Y MAPA
		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.JuggerLevel__oel);
		background = loader.loadTilemap(AssetPaths.ParallexFondo__png, 16, 16, "parallex");
		
		tiles = loader.loadTilemap(AssetPaths.tile_ref__png, 16, 16, "floor");
		otherTiles2 = loader.loadTilemap(AssetPaths.TemplateB__png, 16, 16, "Capa2");
		otherTiles3 = loader.loadTilemap(AssetPaths.TemplateA__png, 16, 16, "Capa1");
		Reg.stairs = new FlxTypedGroup<FlxSprite>();
		
		//SETEAR LAS PROPIEDADES DE LAS COLISIONES
		tiles.setTileProperties(0, FlxObject.NONE);
		otherTiles2.setTileProperties(0, FlxObject.NONE);
		
		//LAS REGLAS A LA CAMARA SOBRE DONDE PUEDE MOVERSE
		FlxG.camera.setScrollBounds(0, tiles.width, 0, tiles.height);
		FlxG.worldBounds.set(0,0,tiles.width,tiles.height);
		
		cameraGuide = new FlxSprite(FlxG.camera.width / 2, FlxG.camera.height / 2);
		//POSICION DEL CAMERA GUIDE PARA ESTAR CERCA DEL BOSS
		cameraGuide.makeGraphic(1, 1, 0x00000000);
		FlxG.camera.follow(cameraGuide);
		
		add(background);
		
		boxes = new FlxTypedGroup<FlxSprite>();
		botiquin = new FlxTypedGroup<Botiquin>();
		enemyOne = new FlxTypedGroup<EneSaltin>();
		enemyTwo = new FlxTypedGroup<Dog>();
		enemyThird = new FlxTypedGroup<EnePlanta>();
		enemyFour = new FlxTypedGroup<EneOjo>();		
		
		add(cameraGuide);
		add(tiles);
		add(otherTiles3);
		add(otherTiles2);
		loader.loadEntities(addEntities, "entities");
		
		
		add(boxes);
		add(Reg.stairs);
		add(enemyFour);
		add(enemyOne);
		add(enemyTwo);
		add(enemyThird);
		add(player);
		add(playerDisparos);
		add(player.hpBar);
		
		music = FlxG.sound.load(AssetPaths.Level__wav, 0.5, true);
		music.play();
		
		//add Boss
		boss = new Boss();
		boss.kill();
		add(boss);
		
	}
	
	var Bosstime : Int = 0;
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		enemyFour.forEach(function(obj : EneOjo)
		{
			obj.Movimiento(player);
		});
		
		enemyThird.forEach(function(obj : EnePlanta)
		{
			obj.Movimiento(player);
		});
			
		player.hpBar.x = player.x;
		player.hpBar.y = player.y - 10;	
		FlxG.collide(tiles, player);
		FlxG.collide(tiles, boss);
		FlxG.collide(tiles, enemyTwo);
		FlxG.collide(tiles, enemyOne);
		FlxG.collide(player,boxes);
		FlxG.overlap(boss, player, null, Colisiones);
		FlxG.overlap(boss, playerDisparos, null, Colisiones);
		FlxG.overlap(boxes, playerDisparos, null, Colisiones);
		FlxG.overlap(enemyOne, playerDisparos, null, Colisiones);
		FlxG.overlap(player, enemyOne, null, Colisiones);
		FlxG.overlap(player, enemyTwo, null, Colisiones);
		FlxG.overlap(enemyTwo, playerDisparos, null, Colisiones);
		FlxG.overlap(enemyThird, playerDisparos, null, Colisiones);
		FlxG.overlap(enemyFour, playerDisparos, null, Colisiones);
		FlxG.overlap(player, botiquin, null, Colisiones);
		if (player.vida <= 0){
			FlxG.resetState();
		}
		
		if (Reg.bossFight){
			FlxG.collide(player, otherTiles);
		}
		if ((cameraGuide.x >= 1989 && cameraGuide.x <= 2072) && cameraGuide.y == 935){
			music.stop();
			music = FlxG.sound.load(AssetPaths.bossLevel__wav, 0.9, true);
			music.play();
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
			if (Bosstime >= Reg.timeAttaqueBoss)
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
		if (entityName == "box"){
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			box = new FlxSprite(X, Y);
			box.immovable = true;
			box.loadGraphic(AssetPaths.caja__png, true, 16, 16);
			boxes.add(box);
		}
		if (entityName == "player"){
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));	
			
			playerDisparos = new FlxTypedGroup<Disparo>();					
			player = new Player(1900, Y, playerDisparos);
		}
		if (entityName == "enemyfour") {
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			var enemy4:EneOjo = new EneOjo(X, Y);
			enemyFour.add(enemy4);
		}
		
		if (entityName == "enemone") {
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"))-32;
			
			var enemy1:EneSaltin = new EneSaltin(X,Y);
			enemyOne.add(enemy1);
		}
		
		if (entityName == "enemytwo") {
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			var enemy2:Dog = new Dog(X,Y);
			enemyTwo.add(enemy2);
		}
		
		if (entityName == "enemythree") {
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			var enemy3:EnePlanta = new EnePlanta(X,Y);
			enemyThird.add(enemy3);
		}
		
		

	}
	
	private function Colisiones(Sprite1:FlxObject, Sprite2:FlxObject): Bool{		
		var sName1:String = Type.getClassName(Type.getClass(Sprite1));
		var sName2:String = Type.getClassName(Type.getClass(Sprite2));
		
		if (sName1 == "sprites.Player" && sName2 == "sprites.Botiquin")
		{
			if(player.vida + 3 >= 10)
				player.vida = 10;
			else
				player.vida += 3;	
			
			player.hpBar.value = player.vida;
			var bot: Dynamic = cast(Sprite2, Botiquin);			
			bot.kill();
			botiquin.remove(bot);			
			return true;
		}
		
		if (sName1 == "sprites.Boss" && sName2 == "sprites.Player")
		{
			player.animation.play("Danio");
			if (player.x >= boss.x)
				player.x += 5;
			if (player.x <= boss.x)
				player.x -= 5;					
			return true;
		}
		
		if (sName1 == "flixel.FlxSprite" && sName2 == "sprites.Disparo"){
			var disp: Dynamic = cast(Sprite2, Disparo);
			disp.kill();
			disp.activado = false;
			
			var _box: Dynamic = cast(Sprite1, FlxSprite);			
			var r : FlxRandom;
			r = new FlxRandom();
			if (r.int(1, 20) <= 5)
			{
				var bot = new Botiquin(_box.x , _box.y);				
				botiquin.add(bot);
				add(bot);
			}
			_box.kill();
			return true;
		}
		
		if (sName1 == "sprites.Boss" && sName2 == "sprites.Disparo")
		{
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
		
		if (sName1 == "sprites.EneSaltin" && sName2 == "sprites.Disparo"){
			var disp: Dynamic = cast(Sprite2, Disparo);
			disp.kill();
			disp.activado = false;
			
			var _salti: Dynamic = cast(Sprite1, EneSaltin);
			_salti.kill();
			return true;
		}
		
		if (sName1 == "sprites.EneOjo" && sName2 == "sprites.Disparo"){
			var disp: Dynamic = cast(Sprite2, Disparo);
			disp.kill();
			disp.activado = false;
			
			var _ojo: Dynamic = cast(Sprite1, EneOjo);
			_ojo.kill();
			return true;
		}
		
		if (sName1 == "sprites.EnePlanta" && sName2 == "sprites.Disparo"){
			var disp: Dynamic = cast(Sprite2, Disparo);
			disp.kill();
			disp.activado = false;
			
			var _pla: Dynamic = cast(Sprite1, EnePlanta);
			_pla.kill();
			return true;
		}
		
		if (sName1 == "sprites.Player" && sName2 == "sprites.EneSaltin"){
			var disp: Dynamic = cast(Sprite2, EneSaltin);
			disp.kill();
			player.vida--;
			player.hpBar.value = player.vida;

			return true;
		}
		
		if (sName1 == "sprites.Player" && sName2 == "sprites.Dog"){
			var disp: Dynamic = cast(Sprite2, Dog);
			disp.kill();
			player.vida--;
			player.hpBar.value = player.vida;

			return true;
		}
		return false;
	}
	
}

