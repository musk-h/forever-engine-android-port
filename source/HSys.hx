package;

import flash.system.System;
import openfl.events.UncaughtErrorEvent;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import haxe.CallStack;
import flixel.FlxG;
import openfl.Lib;

using StringTools;

/*
* by: @Musk-h
* Android tools.
*/
class HSys
{
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
		var something:Array<String> = []; // algo algo, extraño a mi algo:( - musk
		trace('hsys go to: ' + folder);

		for (library in Assets.list().filter(archives -> archives.contains(folder)))
		{
			var splitFolder:Array<String> = [];
			var stringFolder:String = library;

			if (!library.startsWith('.') && !something.contains(folder)) {
				stringFolder = stringFolder.replace(folder + '/', ''); // yea
				splitFolder = stringFolder.split('/');
			}
			if (!something.contains(splitFolder[0])) // para que no se repitan
				something.push(splitFolder[0]);
		}

		// ordenar por abecedario a-z
		something.sort(function(a:String, b:String):Int
		{
			a = a.toUpperCase();
			b = b.toUpperCase();

			if (a < b)
				return -1;
			else if (a > b)
				return 1;
			else
				return 0;
		});

		trace('hsys result is: ' + something);
		return something;
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

	public static function getContent(library:String):String {
		return Assets.getText(library);
	}
	
	public static function androidTouched():Bool
	{
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				justTouched = true;
		}

		#if (flixel && android)
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
