# HaxeFlixel Tutorial 5-9

## Tutorial
Tutorial is linked here:
[https://haxeflixel.com/documentation/tutorial/](https://haxeflixel.com/documentation/tutorial/)
I completed parts 3 and 4 during week 5. This week I completed parts 5 through 9.

### Part 5-6
Part 5 and 6 covered creating and loading the tile-map. This is the space the player will move in.
HaxeFlixel has a built in function for loading tilemaps called FlxOgmoLoader.
This code generates FlxTileMap from the walls layer of the tilemap and properly sets collision for the floors and walls.
```
_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
_mWalls.follow();
_mWalls.setTileProperties(1, FlxObject.NONE);
_mWalls.setTileProperties(2, FlxObject.ANY);
add(_mWalls);
```
This code runs placeEntities() for each entity in the entities layer.
```
_player = new Player();
_map.loadEntities(placeEntities, "entities");
```
This the the placeEntites function:
```
function placeEntities(entityName:String, entityData:Xml):Void
{
    var x:Int = Std.parseInt(entityData.get("x"));
    var y:Int = Std.parseInt(entityData.get("y"));
    if (entityName == "player")
    {
        _player.x = x;
        _player.y = y;
    }
}
```
Which as it is, sets _player's x and y values to the x and y values specified for the player entity in the tilemap.
This code shrinks the player hitbox so the user doesn't have to align perfectly in order to fit through doorways.
```
setSize(8, 14);
offset.set(4, 2);
```
The player should be able to move around in the loaded tilemap:
![Tilemap](https://github.com/yuhangc9321/haxe-independent-study/blob/master/blog-images/0013b.png "Tilemap")  

## Part 7
This part is simple and deals with zoom.  
When the game is initialized in Main.hx, the width and height arguments for FlxGame() need to be reduced.  
Then, in PlayState.hx, this code will tell the camera to follow the player,  
otherwise the player would begin to move off screen very quickly.
```
FlxG.camera.follow(_player, TOPDOWN, 1);
```

## Part 8
This part deals with coin pickups.  
First, coins are added as entities to the tilemap and a coin image asset is saved to assets/images.
A new class is created called Coin.hx and new FlxGroup in PlayState is used to group the coins together.
```
class Coin extends FlxSprite
{
    
    public function new(X:Float=0, Y:Float=0) 
    {
        super(X, Y);
        loadGraphic(AssetPaths.coin__png, false, 8, 8);
    }
}
```
```
var _grpCoins:FlxTypedGroup<Coin>;
```
Then added to the PlayState:  
```
_grpCoins = new FlxTypedGroup<Coin>();
add(_grpCoins);
```
Then, the placeEntities() function from earlier should include another conditional to place coins in additon to the player:
```
else if (entityName == "coin")
{
    _grpCoins.add(new Coin(x + 4, y + 4));
}
```
This code kills the coin when the player overlaps it:
```
FlxG.overlap(_player, _grpCoins, playerTouchCoin);
```
Because of the callback here:
```
function playerTouchCoin(P:Player, C:Coin):Void
{
    if (P.alive && P.exists && C.alive && C.exists)
    {
        C.kill();
    }
}
```
This code in the Coin.hx class allows the coin to fade out using tween.
```
override public function kill():Void
{
    alive = false;
    FlxTween.tween(this, { alpha: 0, y: y - 16 }, .33, { ease: FlxEase.circOut, onComplete: finishKill });
}

function finishKill(_):Void
{
    exists = false;
}
```
The placed coins the the level should look like this:
![Coin example](https://github.com/yuhangc9321/haxe-independent-study/blob/master/blog-images/0016b.png "Coin example")  

### Part 9
Part 9 deals with enemies and ai.  
Enemies are mostly identical to the player class, especially in animation and movement.  
First, they are placed in the tilemap.  
Then, a class is created for them called Enemy.hx
Then a FlxGroup is created for them and they are added to the PlayState.
```
var _grpEnemies:FlxTypedGroup<Enemy>;
```
```
_grpEnemies = new FlxTypedGroup<Enemy>();
add(_grpEnemies);
```
Then a conditional is created for them in placeEnitites().  
```
else if (entityName == "enemy")
{
    _grpEnemies.add(new Enemy(x + 4, y, Std.parseInt(entityData.get("etype"))));
}
```
The ai uses a [finite state machine](https://en.wikipedia.org/wiki/Finite-state_machine) with the states `Idle` and `Chase`.  
```
class FSM
{
    public var activeState:Void->Void;

    public function new(?InitState:Void->Void):Void
    {
         activeState = InitState;
    }

    public function update():Void
    {
        if (activeState != null)
            activeState();
    }
}
```
These functions define the states `Idle` and `Chase`.
```
public function idle():Void
{
    if (seesPlayer)
    {
        _brain.activeState = chase;
    }
    else if (_idleTmr <= 0)
    {
        if (FlxG.random.bool(1))
        {
            _moveDir = -1;
            velocity.x = velocity.y = 0;
        }
        else
        {
            _moveDir = FlxG.random.int(0, 8) * 45;

            velocity.set(speed * 0.5, 0);
            velocity.rotate(FlxPoint.weak(), _moveDir);

        }
        _idleTmr = FlxG.random.int(1, 4);            
    }
    else
        _idleTmr -= FlxG.elapsed;

}

public function chase():Void
{
    if (!seesPlayer)
    {
        _brain.activeState = idle;
    }
    else
    {
        FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
    }
}

override public function update(elapsed:Float):Void
{
    _brain.update();
    super.update(elapsed);
}
```
The enemy switches to `Chase` based on whether they can see the player or not, otherwise they are in `Idle`.
This is the vision logic:
```
 FlxG.collide(_grpEnemies, _mWalls);
 _grpEnemies.forEachAlive(checkEnemyVision);
```
```
function checkEnemyVision(e:Enemy):Void
{
    if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
    {
        e.seesPlayer = true;
        e.playerPos.copyFrom(_player.getMidpoint());
    }
    else
        e.seesPlayer = false;
}
```
And it should look like this:  
![Enemy example](https://github.com/yuhangc9321/haxe-independent-study/blob/master/blog-images/0018b.png "Enemy example")  

## Takeaways
1. **Make use of external links a guide or resource provides.** The wikipedia page of [finite state machines](https://en.wikipedia.org/wiki/Finite-state_machine) helped me understand them better.
2. **Look to reuse code from similar previously written classes.** This advice can also mean using class inheritance more, but just rehashing code in general may help keep things more consistent and save on unnecessary typing too. The enemy class was written with code similar to the player class.

[Previous](week-5.md) | [Home](../README.md) | [Next](week-7.md)