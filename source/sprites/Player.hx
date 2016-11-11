package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import sprites.Disparo;
import flixel.ui.FlxBar;

/**
 * ...
 * @author Sebastian Sforzini
 */
class Player extends FlxSprite
{
	public var shooting:Int = 0;
	public var stairsMove:Bool = false;
	public var statusMovements:String = "jumpFall";
	public var flipVar:Bool = false;
	public var disparos:FlxTypedGroup<Disparo>;
	private static var lado:Bool = true;
	public var vida : Int = 10;
	public var hpBar:FlxBar;
	public static var xs :Float = 0;
	public static var ys :Float = 0;
	
	public function new(?X:Float=0, ?Y:Float=0,playerDisp:FlxTypedGroup<Disparo>) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Titan__png, true, 34, 34);
		acceleration.y = 700;
		disparos = playerDisp;
		animation.add("idle", [0,1], 2);
		animation.add("idle_shoot", [6], 2);
		animation.add("walk", [2, 3,4,5], 8);
		animation.add("jump", [11], 4);
		animation.add("fall", [11], 4);
		animation.add("fall_shoot", [12], 4);
		animation.add("jump_shoot", [12], 4);
		animation.add("moving_shoot", [7, 8, 9, 10], 8);
		animation.add("climb_stairs",[13,14],6);
		animation.add("down_stairs", [13, 14], 6);
		animation.add("Danio", [0,15,0,15,0,15,0,15], 10);
		//player.scale.set(2, 2);
		setSize(25, 25);
		centerOffsets();
		for (i in 0...3){
			var newDisp = new Disparo();
			newDisp.kill();
			disparos.add(newDisp);
		}
		
		//FlxG.watch.add(Player, "xs");
		//FlxG.watch.add(Player, "ys");
		
		hpBar = new FlxBar(this.x, this.y, LEFT_TO_RIGHT, 34, 4);
		//hpBar = new FlxBar(this.x - 125, this.y - 128,BOTTOM_TO_TOP, 8, 100);
		hpBar.createFilledBar(0xFF8e0000, 0xFF00FF00);
		hpBar.setRange(0, vida);
		hpBar.value = vida;		
	}
	
	public function playerMovement():Void
	{			
		xs = this.x;
		ys = this.y;
		if (statusMovements != "ladder"){
			velocity.x = 0;
			acceleration.y = 700;
		}
		
		switch(statusMovements) {		
			
			case "idle":
				flipX = flipVar;
				if (FlxG.keys.pressed.RIGHT) { statusMovements = "running"; lado = true; }	
				if (FlxG.keys.pressed.LEFT) { statusMovements = "running"; lado = false; }	
				if (FlxG.keys.justPressed.X) { 
					shooting = 50;
					Shoot();
				}
				if (shooting <= 0){
					animation.play("idle");
				} else {
					animation.play("idle_shoot");					
				}
				
				
				if (FlxG.keys.justPressed.UP && isTouching(FlxObject.FLOOR)) {
					Reg.jumping = 0;
					velocity.y = -Reg.vSpeed;
					statusMovements = "jumpFall";
				}
				shooting--;
				
				if (FlxG.overlap(Reg.stairs,this) && (FlxG.keys.pressed.UP || FlxG.keys.justPressed.UP)){
					statusMovements = "ladder";
				}
				
			case "ladder":
				if (isTouching(FlxObject.FLOOR)){
					if (FlxG.keys.pressed.RIGHT) { statusMovements = "running"; lado = true; }	
					if (FlxG.keys.pressed.LEFT) { statusMovements = "running"; lado = false; }	
				} else {
					if (FlxG.keys.pressed.DOWN || FlxG.keys.justPressed.DOWN){
						y += 1;
						velocity.y = 0;	
						acceleration.y = 0;
						animation.play("down_stairs");
					}
				}
				
				if (FlxG.keys.pressed.UP || FlxG.keys.justPressed.UP){
					velocity.y = 0;	
					y -= 1;
					acceleration.y = 0;
					animation.play("climb_stairs");
				} else {
					if (!(FlxG.keys.pressed.DOWN || FlxG.keys.justPressed.DOWN)){
						animation.pause();
					}
					if (FlxG.keys.pressed.RIGHT) { statusMovements = "jumpFall"; lado = true; }
					if (FlxG.keys.pressed.LEFT) { statusMovements = "jumpFall"; lado = false; }
				}
				
				if (!FlxG.overlap(Reg.stairs,this)){
					statusMovements = "jumpFall";
				}
			case "running":
				if (velocity.y > 0 ){ statusMovements = "jumpFall"; }
				
				if (FlxG.keys.pressed.RIGHT) { velocity.x += Reg.hSpeed; flipVar = false; lado = true; }					
				if (FlxG.keys.pressed.LEFT) { velocity.x -= Reg.hSpeed; flipVar = true; lado = false; }
				
				if (FlxG.keys.justPressed.UP && isTouching(FlxObject.FLOOR)) {
					Reg.jumping = 0;
					velocity.y = -Reg.vSpeed;
					statusMovements = "jumpFall";
				}
				
				if (FlxG.overlap(Reg.stairs,this) && (FlxG.keys.pressed.UP || FlxG.keys.justPressed.UP)){
					statusMovements = "ladder";
				}
				
				if (isTouching(FlxObject.FLOOR)){
					if (velocity.x == 0) {
						animation.play("idle");
						statusMovements = "idle";
					} else {
						
						if (FlxG.keys.justPressed.X) {
							shooting = 50;
							Shoot();
						}
						
						if (shooting <= 0) {
							animation.play("walk");
						} else {
							animation.play("moving_shoot");
						}
						
						shooting--;
						flipX = flipVar;
					}
				}
			case "jumpFall":
				if (FlxG.keys.pressed.RIGHT) { velocity.x += Reg.hSpeed; flipVar = false; lado = true; }					
				if (FlxG.keys.pressed.LEFT) { velocity.x -= Reg.hSpeed; flipVar = true; lado = false; }
				if (FlxG.keys.justPressed.X) { 
					shooting = 50; 
					Shoot();
				}
				
				if (FlxG.overlap(Reg.stairs,this) && (FlxG.keys.pressed.UP || FlxG.keys.justPressed.UP)){
					statusMovements = "ladder";
				}
				if (velocity.y > 0 ){
					if (shooting <= 0 ){
						animation.play("fall");
					} else {
						animation.play("fall_shoot");
						//ACA SE ACTIVA EL DISPARO
					}
					
					shooting--;
					flipX = flipVar;
				} else {
					if (shooting <= 0 ){
						animation.play("jump");
					} else {
						animation.play("jump_shoot");
						//ACA SE ACTIVA EL DISPARO
					}
					shooting--;
					flipX = flipVar;
				}
				
				
				if (isTouching(FlxObject.FLOOR)){
					shooting = 0;
					statusMovements = "idle";
				}		
		}
	}
	
	private function Shoot():Void{
		var unDisp : Bool = false;
		disparos.forEach(function(obj : Disparo)
		{
			if (obj.activado && (obj.x >= this.x + 128 || obj.x <= this.x - 128))
			{
				obj.activado = false;
			}
			
			if (!obj.activado && !unDisp)
			{
				unDisp = true;
				obj.activado = true;				
				obj.y = this.y + 10;
				if (lado)
				{
					obj.x = this.x + 25;
					obj.velocity.x = 350;
				}
				else
				{
					obj.x = this.x + 5;
					obj.velocity.x = -350;
				}
				obj.revive();
			}
		});
    }
	
	
}