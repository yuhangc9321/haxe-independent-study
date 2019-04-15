# HaxeFlixel

## Haxe
HaxeFlixel is what I'm using to make my product.  
HaxeFlixel is a 2d game engine based on Haxe, but it is not really necessary to know everything about Haxe.  
So I skimmed through this tutorial:  
[https://haxe.org/manual/introduction.html](https://haxe.org/manual/introduction.html)

### Language
Haxe supports object-oriented programming, so it has classes, methods, and other things I'm familliar with.
There are some things that are not present in Javascript or Ruby, but exist in languages like Java.

Classes:
* There are access modifiers such as`static` and `public`.
* There can be a specified return value like `Void`
It is seen in Haxe's `HelloWorld.hx` example:
```
class Main {
  static public function main():Void {
    trace("Hello World");
  }
}
```

## HaxeFlixel
HaxeFlixel provides it's own tutorial:
[https://haxeflixel.com/documentation/getting-started/](https://haxeflixel.com/documentation/getting-started/)

It has intructions for installation and a simple HelloWorld program. 
The program is automatically created by using the template command.
```
flixel tpl -n "HelloWorld"
```
This generates a basic file structure, like the `app-template` I used for Ruby.  
The completed program in `PlayState.hx` looks like this:  

```
package;

import flixel.FlxState;

class PlayState extends FlxState
{
    override public function create():Void
    {
        var text = new flixel.text.FlxText(0, 0, 0, "Hello World", 64);
        text.screenCenter();
        add(text);
        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}
```
This doesn't output directly to the console, but rather displays it visually using FlxText:  
![Hello world example](https://github.com/yuhangc9321/haxe-independent-study/blob/master/blog-images/hello-world.png "Hello world example")
Which is used in the above function create()
```
var text = new flixel.text.FlxText(0, 0, 0, "Hello World", 64);
        text.screenCenter();
        add(text);
```
  
### Testing
Then I'm supposed to use lime to test my program:
```
lime test html5
lime test flash
lime test neko
```
This compiled my program into subdirectories of the `export` folder.
But I couldn't figure out how to use this to get the program to display Hello World.

I looked at these links:
[https://haxeflixel.com/documentation/haxeflixel-targets/](https://haxeflixel.com/documentation/haxeflixel-targets/)
[https://lime.software/docs/command-line-tools/basic-commands/](https://lime.software/docs/command-line-tools/basic-commands/)
And it led me to try `lime setup linux` then `lime test linux`
But the compiling took too long and I had to stop it.

## Takeaways
1. **The first thing isn't always everything.** I read only what was necessary in the Haxe introduction and manual,  
then moved on to HaxeFlixel's library. There were custom methods that learning all of plain Haxe wasn't going to help with understanding, so I tried to familiarize myself with HaxeFlixel as soon as possible, because that's what I'm developing with.
2. **Try to be grounded in prior knowledge.** I'm familiar with classes and methods from object oriented languages like Ruby and Javascript, so it was easy getting through that part and onto HaxeFlixel.
3. **Look to the documentations of the relevant dependencies when stuck.** Some packages can include dependencies, which may have their own documentations, 
so look carefully at the command being typed.

[Previous](../week-2.md) | [Home](../README.md) | [Next](week-4.md)