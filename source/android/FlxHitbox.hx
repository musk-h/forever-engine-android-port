package android;

import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import flixel.FlxSprite;

class FlxHitbox extends FlxSpriteGroup
{
    public var hitbox:FlxSpriteGroup;
    public var buttonLeft:FlxButton;
    public var buttonDown:FlxButton;
    public var buttonUp:FlxButton;
    public var buttonRight:FlxButton;

    var sizeX:Int = 320;
    var sizeY:Int = 720;
    
    public function new(?widghtScreen:Int)
    {
        super();

        var hint:FlxSprite = new FlxSprite();
        hint.loadGraphic('assets/android/hitbox.png');
        hint.alpha = 0.3;
        add(hint);

        sizeX = widghtScreen != null ? Std.int(widghtScreen / 4) : 320;

        hitbox = new FlxSpriteGroup();
        hitbox.scrollFactor.set();
        hitbox.add(add(buttonLeft = createHitbox(0, 'left')));
        hitbox.add(add(buttonDown = createHitbox(sizeX, 'down')));
        hitbox.add(add(buttonUp = createHitbox(sizeX * 2, 'up')));
        hitbox.add(add(buttonRight = createHitbox(sizeX * 3, 'right')));
    }

    public function createHitbox(x:Float, frameString:String) 
    {
        var button = new FlxButton(x, 0);
        var frames = FlxAtlasFrames.fromSparrow('assets/android/hitbox.png', 'assets/android/hitbox.xml');
        var graphic:FlxGraphic = FlxGraphic.fromFrame(frames.getByName(frameString));

        button.loadGraphic(graphic);
        button.alpha = 0;
        button.onDown.callback = function (){
            FlxTween.num(0, 0.75, .075, {ease: FlxEase.circInOut}, function (a:Float) { button.alpha = a; });
        };
        button.onUp.callback = function (){
            FlxTween.num(0.75, 0, .1, {ease: FlxEase.circInOut}, function (a:Float) { button.alpha = a; });
        }
        button.onOut.callback = function (){
            FlxTween.num(button.alpha, 0, .2, {ease: FlxEase.circInOut}, function (a:Float) { button.alpha = a; });
        }

        return button;
    }

    override public function destroy():Void
    {
        super.destroy();
    
        buttonLeft = null;
        buttonDown = null;
        buttonUp = null;
        buttonRight = null;
    }
}