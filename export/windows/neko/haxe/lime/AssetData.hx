package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/data/data-goes-here.txt", "assets/data/data-goes-here.txt");
			type.set ("assets/data/data-goes-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/JuggerLevel.oel", "assets/data/JuggerLevel.oel");
			type.set ("assets/data/JuggerLevel.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/juggermap.oep", "assets/data/juggermap.oep");
			type.set ("assets/data/juggermap.oep", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/level1.oel", "assets/data/level1.oel");
			type.set ("assets/data/level1.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/level2.oel", "assets/data/level2.oel");
			type.set ("assets/data/level2.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/level3.oel", "assets/data/level3.oel");
			type.set ("assets/data/level3.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/level4.oel", "assets/data/level4.oel");
			type.set ("assets/data/level4.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/images/Ata1.png", "assets/images/Ata1.png");
			type.set ("assets/images/Ata1.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/Ata2.png", "assets/images/Ata2.png");
			type.set ("assets/images/Ata2.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/Botiquin.png", "assets/images/Botiquin.png");
			type.set ("assets/images/Botiquin.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/caja.png", "assets/images/caja.png");
			type.set ("assets/images/caja.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/Disparo.png", "assets/images/Disparo.png");
			type.set ("assets/images/Disparo.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/Dog.png", "assets/images/Dog.png");
			type.set ("assets/images/Dog.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/eggv1.png", "assets/images/eggv1.png");
			type.set ("assets/images/eggv1.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/escaleraDoblev1.png", "assets/images/escaleraDoblev1.png");
			type.set ("assets/images/escaleraDoblev1.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/escaleras.png", "assets/images/escaleras.png");
			type.set ("assets/images/escaleras.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/escalerav2.png", "assets/images/escalerav2.png");
			type.set ("assets/images/escalerav2.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/Eyev1.png", "assets/images/Eyev1.png");
			type.set ("assets/images/Eyev1.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/images-go-here.txt", "assets/images/images-go-here.txt");
			type.set ("assets/images/images-go-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/images/Lars2.png", "assets/images/Lars2.png");
			type.set ("assets/images/Lars2.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/LarsEnojado.png", "assets/images/LarsEnojado.png");
			type.set ("assets/images/LarsEnojado.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/ParallexFondo.png", "assets/images/ParallexFondo.png");
			type.set ("assets/images/ParallexFondo.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/Piedra.png", "assets/images/Piedra.png");
			type.set ("assets/images/Piedra.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/Saltin.png", "assets/images/Saltin.png");
			type.set ("assets/images/Saltin.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/stairs.png", "assets/images/stairs.png");
			type.set ("assets/images/stairs.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/TemplateA.png", "assets/images/TemplateA.png");
			type.set ("assets/images/TemplateA.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/TemplateB.png", "assets/images/TemplateB.png");
			type.set ("assets/images/TemplateB.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/tile-ref.png", "assets/images/tile-ref.png");
			type.set ("assets/images/tile-ref.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/Titan.png", "assets/images/Titan.png");
			type.set ("assets/images/Titan.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/music/bossLevel.wav", "assets/music/bossLevel.wav");
			type.set ("assets/music/bossLevel.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/music/juggersong.wav", "assets/music/juggersong.wav");
			type.set ("assets/music/juggersong.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/music/Level.wav", "assets/music/Level.wav");
			type.set ("assets/music/Level.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/music/music-goes-here.txt", "assets/music/music-goes-here.txt");
			type.set ("assets/music/music-goes-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/sounds/sounds-go-here.txt", "assets/sounds/sounds-go-here.txt");
			type.set ("assets/sounds/sounds-go-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("flixel/sounds/beep.ogg", "flixel/sounds/beep.ogg");
			type.set ("flixel/sounds/beep.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("flixel/sounds/flixel.ogg", "flixel/sounds/flixel.ogg");
			type.set ("flixel/sounds/flixel.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("flixel/fonts/nokiafc22.ttf", "flixel/fonts/nokiafc22.ttf");
			type.set ("flixel/fonts/nokiafc22.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("flixel/fonts/monsterrat.ttf", "flixel/fonts/monsterrat.ttf");
			type.set ("flixel/fonts/monsterrat.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("flixel/images/ui/button.png", "flixel/images/ui/button.png");
			type.set ("flixel/images/ui/button.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("flixel/images/logo/default.png", "flixel/images/logo/default.png");
			type.set ("flixel/images/logo/default.png", Reflect.field (AssetType, "image".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
