# Getting Started

## Installing Haxe
These were the first links I found:  
[https://haxe.org/download/](https://haxe.org/download/)  
[https://ashes999.github.io/learnhaxe/haxeflixel-in-cloud9.html](https://ashes999.github.io/learnhaxe/haxeflixel-in-cloud9.html)  

Step 1 of the tutorial above didn't work so I downloaded the linux software package rather than the linux binary like they said.  
The following commands download Haxe and Neko from Haxe Foundation's "Personal Package Archive":  
```
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
mkdir ~/haxelib && haxelib setup ~/haxelib
```  

## Installing related

HaxeFlixel and OpenFL were installed with the following guide and commands:  
[https://haxeflixel.com/documentation/install-haxeflixel/](https://haxeflixel.com/documentation/install-haxeflixel/)  

Install latest version of HaxeFlixel:
```
haxelib install lime
haxelib install openfl
haxelib install flixel
```

Additional libraries:
```
haxelib run lime setup flixel
```

Installing `lime` command:
```
haxelib run lime setup
```

Installing `flixel` command:
```
haxelib install flixel-tools
haxelib run flixel-tools setup
```

Update HaxeFlixel:
```
haxelib update flixel
```

## Language

Haxe Foundation's language introduction:  
[https://haxe.org/documentation/introduction/language-introduction.html](https://haxe.org/documentation/introduction/language-introduction.html)  

A simple Hello World program can be written like this:  
```
class HelloWorld {
    static public function main() {
        trace("Hello World");
    }
}
```

### Compiler
The extension for Haxe files is .hx  
Haxe provides compiler targets for many languages.  

The following command compiles the "HelloWorld.hx" file to Javascipt:  
```
haxe -main HelloWorld -js HelloWorld.js
```
The Haxe compiler can be invoked like this too:
```
haxe -main HelloWorld --interp
```
Which outputs `Main.hx:3: Hello world`.

## Takeaways
1. Try exploring other solutions if the first doesn't work.
2. Begin with something simple so as to not get overwhelmed.
3. Read instructions carefully. It's easy to get lost.

[Previous](../week-1.md) | [Home](../README.md) | [Next](week-3.md)