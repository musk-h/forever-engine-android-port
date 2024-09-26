package;

import flash.system.System;
import openfl.events.UncaughtErrorEvent;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import haxe.CallStack;
import flixel.FlxG;
import openfl.Lib;
import haxe.io.Path;

using StringTools;

/*
* by: @Musk-h
* Android tools.
*/
class HSys
{
	// tecnicamente esta lista siempre sera la misma
	// asiq por temas de rendimiento mejor la guardamos enla ram 
	// en vez de hacer el mismo metodo siempre
	public static var assetList:Array<String> = Assets.list();
	
	public static function initCrashHandler()
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(e:UncaughtErrorEvent)
		{
			var errMsg:String = "";
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var dateNow:String = Date.now().toString();

			dateNow = StringTools.replace(dateNow, " ", "_");
			dateNow = StringTools.replace(dateNow, ":", "'");

			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case FilePos(s, file, line, column):
						errMsg += file + " (line " + line + ")\n";
					default:
						errMsg += stackItem;
				}
			}

			errMsg += '\nUncaught Error: ' + e.error;

			Lib.application.window.alert(errMsg, 'Crash!');
			System.exit(1);
		});
	}

	// la cereza del pastel
	public static function readDirectory(folder:String):Array<String>
	{
        var result = [];
    
        for (library in assetList.filter(archives -> archives.contains(folder))) {
            if (!library.startsWith('.')) {
                var name = library.replace(folder + '/', '').split('/')[0];
                // contains pero un poooco mas rapido
                if (result.indexOf(name) == -1)
                    result.push(name);
            }
        }
    
        result.sort((a, b) -> {
            return a.toUpperCase() < b.toUpperCase() ? -1 : (a.toUpperCase() > b.toUpperCase() ? 1 : 0);
        });
    
        return result;
    }

	public static function exists(folder:String, ?type:AssetType = null):Bool
	{
		var format:String = '';

		switch (type)
		{
			case FONT:
				format = '.ttf';
				if (!Assets.exists(folder + format))
					format = '.otf';
			case IMAGE:
				format = '.png';
			case MOVIE_CLIP:
				format = '.swf';
			case MUSIC | SOUND:
				format = '.ogg';
			case TEXT:
				format = '.txt';
				if (!Assets.exists(folder + format))
					format = '.xml';
			case BINARY | TEMPLATE:
				format = '.null';
				trace('Return: Put the file format in the path.');
		}

		return Assets.exists(folder + format);
	}

	public static function getContent(library:String):String
		return Assets.getText(library);
	
	public static function androidTouched():Bool
	{
	    #if (flixel && android)
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				justTouched = true;
		}
 		return justTouched;
		#else
 		return false;
		#end
	}

	public static function androidBack():Bool
	{
		#if (flixel && android)
 		return FlxG.android.justReleased.BACK;
		#else
 		return false;
		#end
	}
}
