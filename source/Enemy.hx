package;

import Controls;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard.FlxKeyInput;
import flixel.input.keyboard.FlxKeyboard;

class Enemy extends FlxSprite
{
	var enemySprite:FlxSprite;
	var moveSpeed:Float = 0.75;
	var playerReference:Player;
	var playstateReference:PlayState;

	public function new(playerRef:Player)
	{
		super();
		playerReference = playerRef;
		playstateReference = cast FlxG.state;
		enemySprite = loadGraphic("assets/images/enemy.png", true, 16, 16);
		enemySprite.updateHitbox();
		enemySprite.animation.add("Idle", [0, 1], 5, true);
		enemySprite.animation.play("Idle");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!playerReference.isDead)
		{
			FlxG.overlap(this, playstateReference.player, EnemyOBLITERATESPlayer);
		}

		MoveEnemy(1 * moveSpeed);
	}

	function MoveEnemy(moveDir:Float)
	{
		if (!playerReference.isDead)
		{
			if (x < playerReference.x)
			{
				x += moveDir;
			}
			if (x > playerReference.x)
			{
				x -= moveDir;
			}
		}
	}

	function EnemyOBLITERATESPlayer(obj1:FlxObject, obj2:FlxObject)
	{
		playstateReference.ShowRetryScreen();
		playerReference.Die();
	}
}
