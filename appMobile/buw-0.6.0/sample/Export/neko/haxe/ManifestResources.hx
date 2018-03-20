package;


import lime.app.Config;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {
	
	
	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	
	
	public static function init (config:Config):Void {
		
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
		
		var rootPath = null;
		
		if (config != null && Reflect.hasField (config, "rootPath")) {
			
			rootPath = Reflect.field (config, "rootPath");
			
		}
		
		if (rootPath == null) {
			
			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif (windows && !cs)
			rootPath = FileSystem.absolutePath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) Sys.programPath () #else Sys.executablePath () #end)) + "/";
			#else
			rootPath = "";
			#end
			
		}
		
		Assets.defaultRootPath = rootPath;
		
		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_montserrat_bold_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_montserrat_regular_ttf);
		
		#end
		
		var data, manifest, library;
		
		Assets.libraryPaths["default"] = rootPath + "manifest/default.json";
		
		
		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		
		
	}
	
	
}


#if !display
#if flash



#elseif (desktop || cpp)


@:keep #if display private #end class __ASSET__assets_fonts_montserrat_bold_ttf extends lime.text.Font { public function new () { __fontPath = #if (ios || tvos) "assets/" + #end "assets/fonts/montserrat-bold.ttf"; name = "Montserrat-Bold"; super (); }}
@:keep #if display private #end class __ASSET__assets_fonts_montserrat_regular_ttf extends lime.text.Font { public function new () { __fontPath = #if (ios || tvos) "assets/" + #end "assets/fonts/montserrat-regular.ttf"; name = "Montserrat-Regular"; super (); }}


#else

@:keep @:expose('__ASSET__assets_fonts_montserrat_bold_ttf') #if display private #end class __ASSET__assets_fonts_montserrat_bold_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/montserrat-bold.ttf"; #end name = "Montserrat-Bold"; super (); }}
@:keep @:expose('__ASSET__assets_fonts_montserrat_regular_ttf') #if display private #end class __ASSET__assets_fonts_montserrat_regular_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/montserrat-regular.ttf"; #end name = "Montserrat-Regular"; super (); }}


#end

#if (openfl && !flash)

@:keep @:expose('__ASSET__OPENFL__assets_fonts_montserrat_bold_ttf') #if display private #end class __ASSET__OPENFL__assets_fonts_montserrat_bold_ttf extends openfl.text.Font { public function new () { #if !html5 __fontPath = #if (ios || tvos) "assets/" + #end "assets/fonts/montserrat-bold.ttf"; #end name = "Montserrat-Bold"; super (); }}
@:keep @:expose('__ASSET__OPENFL__assets_fonts_montserrat_regular_ttf') #if display private #end class __ASSET__OPENFL__assets_fonts_montserrat_regular_ttf extends openfl.text.Font { public function new () { #if !html5 __fontPath = #if (ios || tvos) "assets/" + #end "assets/fonts/montserrat-regular.ttf"; #end name = "Montserrat-Regular"; super (); }}


#end
#end