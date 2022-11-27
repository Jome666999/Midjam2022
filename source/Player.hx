package;

import Controls;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard.FlxKeyInput;
import flixel.input.keyboard.FlxKeyboard;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	var playerSprite:FlxSprite;
	var moveSpeed:Float = 0.9;
	var canShoot:Bool = true;
	var shootCooldown:Float = 0.9;

	public var isDead:Bool = false;

	public var lastFacedDirection:Bool = true; // false = left, true = right. Default is true because player spawns facing right

	public function new()
	{
		super();
		playerSprite = loadGraphic("assets/images/player.png", true, 16, 16);
		playerSprite.updateHitbox();
		playerSprite.animation.add("Idle", [0, 1, 2, 3], 5, true);
		playerSprite.animation.add("Shoot", [4, 5, 6], 5, false);
		playerSprite.animation.add("Walk", [7, 8, 9, 10, 11, 12], 5, true);
		playerSprite.animation.add("Dead", [13], 5, false);
		playerSprite.animation.play("Idle");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!isDead)
		{
			if (FlxG.keys.anyPressed(Controls.WALKLEFT))
			{
				playerSprite.animation.play("Walk");
				playerSprite.flipX = true;
				lastFacedDirection = false;

				MovePlayer(-1 * moveSpeed);
			}
			if (FlxG.keys.anyPressed(Controls.WALKRIGHT))
			{
				playerSprite.animation.play("Walk");
				playerSprite.flipX = false;
				lastFacedDirection = true;

				MovePlayer(1 * moveSpeed);
			}
			if (FlxG.keys.anyJustPressed(Controls.SHOOT) && canShoot)
			{
				canShoot = false;
				playerSprite.animation.play("Shoot");
				ShootBullet();
			}

			if (!FlxG.keys.anyPressed(Controls.MOVEMENTKEYS) && playerSprite.animation.name != "Shoot")
			{
				playerSprite.animation.play("Idle");
			}

			// if shooting anim has stopped, go back to idle
			if (playerSprite.animation.name == "Shoot" && playerSprite.animation.finished)
			{
				playerSprite.animation.play("Idle");
			}
		}
	}

	function MovePlayer(moveDir:Float)
	{
		var uhhMoveClampThingIDK:Float = moveDir;

		// Clamp the player inside bounds. There's prolly a better way to do this but bruhhh I started half way through the jam, I ain't doing research lol
		if (x + moveDir < 214 || x + moveDir > 410)
		{
			uhhMoveClampThingIDK = 0;
		}

		x += uhhMoveClampThingIDK;
	}

	function ShootBullet()
	{
		var playState:PlayState = cast FlxG.state;
		playState.ShootBullet(lastFacedDirection);

		var shootCooldownTimer = new FlxTimer().start(shootCooldown, function(tmr:FlxTimer)
		{
			trace("Can shoot again");
			canShoot = true;
		});
	}

	public function Die()
	{
		if (!isDead)
		{
			trace("You suck");

			playerSprite.animation.play("Dead");
			FlxG.sound.play("assets/sounds/playerdeathohnososad.wav");
			isDead = true;
		}
	}
}
