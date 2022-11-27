package;

import flixel.FlxState;
import flixel.input.keyboard.FlxKey;

class Controls
{
	// Movement
	static public var MOVEMENTKEYS:Array<FlxKey> = [A, D, LEFT, RIGHT]; // used to ask if any of these keys are/are not pressed. not used for actual movement
	static public var WALKLEFT:Array<FlxKey> = [A, LEFT];
	static public var WALKRIGHT:Array<FlxKey> = [D, RIGHT];

	// General
	static public var SHOOT:Array<FlxKey> = [SPACE, F];
	static public var RETRY:Array<FlxKey> = [R]; // only used when player is dead
	static public var EASTEREGG:Array<FlxKey> = [W, UP];
}
