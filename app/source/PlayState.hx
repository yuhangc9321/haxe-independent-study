package;

import flixel.FlxState;

class PlayState extends FlxState
{
	var _grpItems:FlxTypedGroup<Item>;
	
	override public function create():Void
	{
		_grpItems = new FlxTypedGroup<
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
