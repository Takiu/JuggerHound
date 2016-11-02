package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import sprites.Player;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;

class PlayState extends FlxState
{
	private var player:FlxSprite;
	private var platform:FlxSprite;
	private var test:Int = 0;
	private var test2:Float = 0;
	public var background:FlxTilemap;
	public var tiles:FlxTilemap;
	public var otherTiles:FlxTilemap;
	public var cameraGuide:FlxSprite;
	
	override public function create():Void
	{
		super.create();
		
		//TODA LA CREACION DEL NIVEL Y MAPA
		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.level3__oel);
		//background = loader.loadTilemap(AssetPaths.tile_ref__png, 16, 32, "Background");
		
		tiles = loader.loadTilemap(AssetPaths.tile_ref__png, 16, 16, "floor");
		//otherTiles = loader.loadTilemap(AssetPaths.OtherTiles__png, 16, 16, "OtherTiles");
		
		//SETEAR LAS PROPIEDADES DE LAS COLISIONES
		//background.setTileProperties(0, FlxObject.NONE);
		tiles.setTileProperties(0, FlxObject.NONE);
		
		//player = new Player(100, 650);
		player = new FlxSprite(100, 650);
		player.loadGraphic(AssetPaths.Titan__png, true, 34, 34);
		player.acceleration.y = 700;
		player.animation.add("idle", [0,1], 2);
		player.animation.add("walk", [2, 3,4,5], 8);
		player.animation.add("jump", [11], 4);
		player.animation.add("fall", [11], 4);
		player.animation.add("moving_shoot", [7,8,9,10], 8);
		//player.scale.set(2, 2);
		player.setSize(25, 25);
		player.centerOffsets();
		
		//FLXG.WORDBOUND.SET(X,Y); PARA SETEAR EL AREA DE COLISION
		
		//LAS REGLAS A LA CAMARA SOBRE DONDE PUEDE MOVERSE
		FlxG.camera.setScrollBounds(0, 848*4, 848, 848);
		FlxG.worldBounds.set(0,0,848*4,848);
		
		cameraGuide = new FlxSprite(FlxG.camera.width / 2, FlxG.camera.height / 2);
		//POSICION DEL CAMERA GUIDE PARA ESTAR CERCA DEL BOSS
		//cameraGuide = new FlxSprite(25600 - 700, FlxG.camera.height / 2);
		cameraGuide.makeGraphic(1, 1, 0x00000000);
		FlxG.camera.follow(cameraGuide);
		
		//add(background);
		add(tiles);
		add(cameraGuide);
		//add(trail);
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(tiles, player);
		playerMovement();
		test2 += elapsed;
		cameraGuide.x = player.x;
		
		//cameraGuide.velocity.y = 150;
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
	}
	
	private function playerMovement():Void
	{
		player.velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT) {
			player.velocity.x += Reg.hSpeed;
		}
			
		if (FlxG.keys.pressed.LEFT) {
			
			player.velocity.x -= Reg.hSpeed;
		}
			
		
		if (FlxG.keys.justPressed.UP && player.isTouching(FlxObject.FLOOR)) {			
			test2 = 0;
			player.velocity.y = -Reg.vSpeed;
		} else if (FlxG.keys.pressed.UP && test2 <= Reg.maxJumpTime) {
			player.velocity.y -= Reg.vSpeed / 25;
		}
		
		
		
			
		if (player.velocity.y > 0){
			if (player.velocity.x > 0)
			{
				test--;
				player.animation.play("fall");
				player.flipX = false;
			} else {
				test--;
				player.animation.play("fall");
				player.flipX = true;
			}
		} else if (player.velocity.y < 0) {
			if (player.velocity.x > 0)
			{
				player.animation.play("jump");
				player.flipX = false;
			} else {
				player.animation.play("jump");
				player.flipX = true;
			}
			
		} else if (player.isTouching(FlxObject.FLOOR))
		{
			if (player.velocity.x > 0)
			{
				if (FlxG.keys.justPressed.X) {
					test = 50;
				}
				
				if (test <= 0 && FlxG.keys.pressed.RIGHT) {
					player.animation.play("walk");
				} else {
					player.animation.play("moving_shoot");
				}
				
				test--;
				player.flipX = false;
			}
			else if (player.velocity.x < 0)
			{
				
				if (FlxG.keys.justPressed.X) {
					test = 50;
				}
				
				if (test <= 0 && FlxG.keys.pressed.LEFT) {
					player.animation.play("walk");
				} else {
					player.animation.play("moving_shoot");
				}
				
				test--;
				player.flipX = true;
			}
			else {
				
				test--;
				player.animation.play("idle");
			}
		}
	}
}

