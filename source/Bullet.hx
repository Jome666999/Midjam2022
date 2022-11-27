package;

import Controls;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard.FlxKeyInput;
import flixel.input.keyboard.FlxKeyboard;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	var bulletSprite:FlxSprite;
	var moveSpeed:Float = 1;
	var playerReference:Player;
	var playstateReference:PlayState;
	var moveDir:Int;

	public function new(playerRef:Player)
	{
		super();
		playerReference = playerRef;
		if (!playerReference.lastFacedDirection)
		{
			moveDir = -1;
		}
		else
		{
			moveDir = 1;
		}

		playstateReference = cast FlxG.state;
		bulletSprite = makeGraphic(2, 2, FlxColor.YELLOW, false);
		bulletSprite.updateHitbox();
		bulletSprite.animation.add("Idle", [0, 1], 5, true);
		bulletSprite.animation.play("Idle");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.overlap(playstateReference.bullets, playstateReference.enemies, OhShitCollisionMoment);
		if (!isOnScreen())
		{
			trace("bullet no longer on screen so we killed it lol");
			kill();
		}

		MoveBullet();
	}

	function MoveBullet()
	{
		x += moveDir * moveSpeed;
	}

	function OhShitCollisionMoment(obj1:FlxObject, obj2:FlxObject)
	{
		FlxG.sound.play("assets/sounds/enemydeath.wav");
		playstateReference.enemiesDefeated += 1;
		playstateReference.enemyMaxSpawnTime -= 0.1;
		if (playstateReference.enemyMaxSpawnTime < 1)
		{
			playstateReference.enemyMaxSpawnTime = 1;
		}
		obj1.kill();
		obj2.kill();
	}
}
