# HaxeFlixel Tutorial

## Building and running
As a workaround to my problem with testing in flash, I built and ran the codebase in html5 for now, which creates an index.html that previews in the Cloud9 IDE fine.

## Tutorial
The HaxeFlixel tutorial provides steps on how to create a basic dungeon crawler.
[https://haxeflixel.com/documentation/tutorial/](https://haxeflixel.com/documentation/tutorial/)
Part 1 and 2 of the HaxeFlixel tutorial covered the setup of the project and the creation of a simple HelloWorld program.  
I completed these parts during week 3. This week I finished parts 3 and 4.  

### Part 3
Titled "Groundwork", this part provides a guide on how to create a play button and movement for a basic graphic.  
[https://haxeflixel.com/documentation/groundwork/](https://haxeflixel.com/documentation/groundwork/)

This section helped me understand `FlxState`s:  
[https://haxeflixel.com/documentation/flxstate/](https://haxeflixel.com/documentation/flxstate/) 
In HaxeFlixel, levels and menus are ordered into "states" to keeps thing more organized.  
One can switch states to access only the code that's needed.  

I created a `MenuState` class, which inherits from `FlxState`.  
Then, a `FlxButton` object is created and added to the `MenuState`.  
This button switches states from `MenuState` to `PlayState`.  
```
class MenuState extends FlxState
{
	var _btnPlay:FlxButton;

	override public function create():Void
	{
		_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		add(_btnPlay);
		_btnPlay.screenCenter();
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
}
```
Then, I created a `Player` class and initialzed it with these commands:
This inherits from `FlxSprite`:  
```
package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Player extends FlxSprite
{
    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
    }
}
```
This command creates a new variable with type `Player`:  
```
var _player:Player;
```
And this uses the makeGraphic method to create a placeholder image:  
```
makeGraphic(16, 16, FlxColor.BLUE);
```
This adds the `Player` object to the `PlayState`:  
```
_player = new Player(20, 20);
add(_player);
```

### Part 4
Part four, named "Sprites and Animation", teaches the reader how to use an imported image asset containing sprites to display different character orientations for the player.
[https://haxeflixel.com/documentation/sprites-and-animation/](https://haxeflixel.com/documentation/sprites-and-animation/)

This is the command for generating a HaxelFlixel template.
```
flixel tpl -n "TemplateName"
```
The tutorial linked above generously provided artwork for animation frames.
I placed this in the automatically created  /assets/images directory.
This code references the art asset and loads the image onto a sprite.
```
loadGraphic(AssetPaths.player__png, true, 16, 16);
```
It should look like this:  
![Groundwork example](https://github.com/yuhangc9321/haxe-independent-study/blob/master/blog-images/0006.png "Groundwork example")  

## Takeaways
1. **Practicing good organization in the start can help a lot later.** The same goes the other way. Bad organization compounds when left ignored.  
"If you can't affored to do it right then you can't afford to do it over." I made use of HaxeFlixel's state stucture.
2. **Mockups don't need to be perfect** There's not need to flush out every aspect of a mockup when most of that code is going to be changed or scrapped in the final product. It's only a demonstration of basic functionality.

[Previous](week-4.md) | [Home](../README.md) | [Next](week-6.md)