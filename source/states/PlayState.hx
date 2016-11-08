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

class PlayState extends FlxState
{
	private var player:Player;
	public var background:FlxTilemap;
	public var tiles:FlxTilemap;
	public var otherTiles:FlxTilemap;
	public var cameraGuide:FlxSprite;
	public var stair:FlxSprite;
	
	override public function create():Void
	{
		super.create();
		
		//TODA LA CREACION DEL NIVEL Y MAPA
		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.level4__oel);
		//background = loader.loadTilemap(AssetPaths.tile_ref__png, 16, 32, "Background");
		
		tiles = loader.loadTilemap(AssetPaths.tile_ref__png, 16, 16, "floor");
		otherTiles = loader.loadTilemap(AssetPaths.stairs__png, 16, 16, "stairs");
		Reg.stairs = new FlxTypedGroup<FlxSprite>();
		loader.loadEntities(addEntities, "entities");
		
		//SETEAR LAS PROPIEDADES DE LAS COLISIONES
		tiles.setTileProperties(0, FlxObject.NONE);
		
		//LAS REGLAS A LA CAMARA SOBRE DONDE PUEDE MOVERSE
		FlxG.camera.setScrollBounds(0, 848*4, 0, 848);
		FlxG.worldBounds.set(0,0,848*4,848);
		
		cameraGuide = new FlxSprite(FlxG.camera.width / 2, FlxG.camera.height / 2);
		//POSICION DEL CAMERA GUIDE PARA ESTAR CERCA DEL BOSS
		cameraGuide.makeGraphic(1, 1, 0x00000000);
		FlxG.camera.follow(cameraGuide);
		
		//add(background);
		add(tiles);
		add(otherTiles);
		add(cameraGuide);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(tiles, player);
		if ((cameraGuide.x >= 1769 && cameraGuide.x <= 1864) && cameraGuide.y == 791){
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
			if (cameraGuide.x <= 1864){
				cameraGuide.x++;
			} else {
				Reg.bossFightBegins = false;
			}
		}
		
		Reg.jumping += elapsed;
	}
	
	private function addEntities(entityName:String, entityData:Xml):Void
	{
		
		if (entityName == "escaleras")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			
			stair = new FlxSprite(X, Y);
			stair.loadGraphic(AssetPaths.escaleras__png, true, 16, 160);
			Reg.stairs.add(stair);
		
		}
		if (entityName == "escalerachica"){
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			stair = new FlxSprite(X, Y);
			stair.loadGraphic(AssetPaths.escaleras__png, true, 16, 96);
			Reg.stairs.add(stair);
		}
		if (entityName == "player"){
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			player = new Player(X, Y);
			
		}
		
		add(Reg.stairs);
		add(player);
	}
}

