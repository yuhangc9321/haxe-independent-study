package;

import flixel.FlxState;
import flixel.FlxG;

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