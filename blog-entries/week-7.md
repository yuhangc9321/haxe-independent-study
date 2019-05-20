# HaxeFlixel Tutorial 10-12

## Tutorial
[https://haxeflixel.com/documentation/tutorial/](https://haxeflixel.com/documentation/tutorial/)  
I completed parts 5 through 9 during week 6. This week I completed parts 10 through 12.  
I am (probably) not planning on completing parts 13 and 14.  
Part 13 covers adding conditionals to make the game work better when built to different platforms.
Part 14 covers polish (minor additional effects regarding graphics and such).

## Part 10
Part 10 covers the user interface and the combat screen.  
This HUD class initializes and adds a background, FlxText objects for health and money, and icons to go beside those.
The `spr.scrollFactor.set(0, 0);` surrounded by a for loop is meant to make these HUD objects stay on the same position relative to the screen.  
```
package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
    var _sprBack:FlxSprite;
    var _txtHealth:FlxText;
    var _txtMoney:FlxText;
    var _sprHealth:FlxSprite;
    var _sprMoney:FlxSprite;

    public function new()
    {
        super();
        _sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
        _sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
        _txtHealth = new FlxText(16, 2, 0, "3 / 3", 8);
        _txtHealth.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        _txtMoney = new FlxText(0, 2, 0, "0", 8);
        _txtMoney.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        _sprHealth = new FlxSprite(4, _txtHealth.y + (_txtHealth.height/2)  - 4, AssetPaths.health__png);
        _sprMoney = new FlxSprite(FlxG.width - 12, _txtMoney.y + (_txtMoney.height/2)  - 4, AssetPaths.coin__png);
        _txtMoney.alignment = RIGHT;
        _txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
        add(_sprBack);
        add(_sprHealth);
        add(_sprMoney);
        add(_txtHealth);
        add(_txtMoney);
        forEach(function(spr:FlxSprite)
        {
            spr.scrollFactor.set(0, 0);
        });
    }

    public function updateHUD(Health:Int = 0, Money:Int = 0):Void
    {
        _txtHealth.text = Std.string(Health) + " / 3";
        _txtMoney.text = Std.string(Money);
        _txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
    }
}
```
To allow the _txtMoney and _txtHealth FlxText to update, variables for them need to be initialized and added to PlayState.  
```
var _hud:HUD;
var _money:Int = 0;
var _health:Int = 3;
```
```
_hud = new HUD();
add(_hud);
```
Then, in the playerTouchCoin() function, these variables will be updated.  
```
_money++;
_hud.updateHUD(_health, _money);
```
It should look like this so far and the coin count should update when coins are picked up.  
![Coin hud](https://github.com/yuhangc9321/haxe-independent-study/blob/master/blog-images/0019.png "Coin hud")  

For the health to be updated on the HUD, the combat must be implemented first, so the player can be damaged.
The tutorial provides a CombatHUD.hx class.
It handles turn based combat logic and returns an outcome of `ESCAPE`, `VICTORY`, or `DEFEAT`.  

This initializes and adds the CombatHUD class in PlayState
```
var _inCombat:Bool = false;
var _combatHud:CombatHUD;
```
```
_combatHud = new CombatHUD();
add(_combatHud);
```
The update() function is changed so as to not check for collision while the player is in combat.  
```
if (!_inCombat)
{
    FlxG.collide(_player, _mWalls);
    FlxG.overlap(_player, _grpCoins, playerTouchCoin);
    FlxG.collide(_grpEnemies, _mWalls);
    _grpEnemies.forEachAlive(checkEnemyVision);
    FlxG.overlap(_player, _grpEnemies, playerTouchEnemy);
}
else
{
    if (!_combatHud.visible)
    {
        _health = _combatHud.playerHealth;
        _hud.updateHUD(_health, _money);
        if (_combatHud.outcome == VICTORY)
        {
            _combatHud.e.kill();
        }
        else
        {
            _combatHud.e.flicker();
        }
        _inCombat = false;
        _player.active = true;
        _grpEnemies.active = true;
    }
}
```
These functions in PlayState initiate combat when the player collides with an enemy and that enemy is not stunned.
```
function playerTouchEnemy(P:Player, E:Enemy):Void
{
    if (P.alive && P.exists && E.alive && E.exists && !E.isFlickering())
    {
        startCombat(E);
    }
}

function startCombat(E:Enemy):Void
{
    _inCombat = true;
    _player.active = false;
    _grpEnemies.active = false;
    _combatHud.initCombat(_health, E);
}
```
The CombatHUD should look like this:
![CombatHUD](https://github.com/yuhangc9321/haxe-independent-study/blob/master/blog-images/0020b.png "CombatHUD")  

## Part 11
Part 11 covers winning and losing and a game over screen.

Variables are added to PlayState for marking if the game is ending and if the player has won.
```
var _ending:Bool;
var _won:Bool;
```
This code in update() stops everything from updating if the game is ending, which is when the game switches to the game over state.
```
if (_ending)
{
    return;
}
```
Then in update, this logic fades the screen out and uses the callback function doneFadeOut if the player was defeated or they defeated the boss.
```
if (!_combatHud.visible)
{
    _health = _combatHud.playerHealth;
    _hud.updateHUD(_health, _money);
    if (_combatHud.outcome == DEFEAT)
    {
        _ending = true;
        FlxG.camera.fade(FlxColor.BLACK, .33, false, doneFadeOut);
    }
    else
    {
        if (_combatHud.outcome == VICTORY)
        {
            _combatHud.e.kill();
            if (_combatHud.e.etype == 1)
            {
                _won = true;
                _ending = true;
                FlxG.camera.fade(FlxColor.BLACK, .33, false, doneFadeOut);
            }
        }
        else
        {
            _combatHud.e.flicker();
        }
        _inCombat = false;
        _player.active = true;
        _grpEnemies.active = true;
    }
}
```
The callback function doneFadeOut switches from PlayState to GameOverState and passes whether they won and how much money they had.
```
function doneFadeOut():Void
{
    FlxG.switchState(new GameOverState(_won, _money));
}
```

## Part 12
Part 12 deals with sounds.
The tutorial provides some .wav files to be placed into assets/sounds and assets/music.  

This code in MenuState makes the music loop when the game begins.
```
if (FlxG.sound.music == null) // don't restart the music if it's already playing
{
    FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__mp3, 1, true);
}
```
In MenuState's create(), this lets buttons make a sound when clicked.
```
_btnPlay.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
```
This code in Player.hx creates a FlxSound for step.wav.
```
var _sndStep:FlxSound;
```
```
_sndStep = FlxG.sound.load(AssetPaths.step__wav);
```
This goes in the check for if the player is moving and plays step.wav.
```
_sndStep.play();
```
Enemies also get footsteps, but their volume varies based on distance to the player.
In Enemy.hx:
```
var _sndStep:FlxSound;
```
```
_sndStep = FlxG.sound.load(AssetPaths.step__wav,.4);
_sndStep.proximity(x,y,FlxG.camera.target, FlxG.width *.6);
```
A check for whether the enemy is moving:
```
if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
{
    _sndStep.setPosition(x + frameWidth / 2, y + height);
    _sndStep.play();
}
```
_sndCoin is initialized in PlayState.
```
var _sndCoin:FlxSound;
```
```
_sndCoin = FlxG.sound.load(AssetPaths.coin__wav);
```
In the playerTouchCoin() function:
```
_sndCoin.play(true);
```

Takeaways
1. **Find the data type that fits best.** In this language, the type names are intuitive (e.g. FlxSound) so it helps make coming back to the code again later easier.
This advice applied other languages could mean using a hash map may not be necessary when an array would suffice. Or that it would be better to use a bool rather than a string or a integer for toggling between two things.
This helps avoid unnecessary complexity in code and makes reading it easier.
2. **Think about good UX.** The developer can be too used to their own product that some problems can go unnoticed. Try asking a friend test out your product and give feedback.


[Previous](week-6.md) | [Home](../README.md) | [Next](week-8.md)
