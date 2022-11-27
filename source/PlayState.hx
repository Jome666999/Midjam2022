package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIText;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKeyboard.FlxKeyInput;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var player:Player;
	public var enemies:FlxGroup;
	public var bullets:FlxGroup;
	public var enemiesDefeated:Int = 0;
	public var enemyMaxSpawnTime:Float = 5;

	var gameCam:FlxCamera;
	var hudCam:FlxCamera;

	var enemiesDefeatedText:FlxUIText;
	var retryScreen:FlxSprite;
	var womanEasterEgg:FlxSprite; // idk how else to add the optional theme at this point so imma just add as an easter egg lmao. not really a theme but ehh

	override public function create()
	{
		super.create();

		FlxG.mouse.visible = false;

		enemies = new FlxGroup();
		bullets = new FlxGroup();

		gameCam = new FlxCamera(0, 0, FlxG.width, FlxG.height, 0);
		gameCam.zoom = 3; // zoom set here because it messes up if set on above line :(((
		FlxG.cameras.reset(gameCam);

		hudCam = new FlxCamera(0, 0, FlxG.width, FlxG.height, 0);
		hudCam.bgColor.alpha = 0;
		FlxG.cameras.add(hudCam);

		enemiesDefeatedText = new FlxUIText(10, 10, FlxG.width - 10, "Killed: 0", 20);
		enemiesDefeatedText.color = FlxColor.WHITE;
		enemiesDefeatedText.cameras = [hudCam];
		add(enemiesDefeatedText);

		womanEasterEgg = new FlxSprite().loadGraphic("assets/images/womaneelol.png", false);
		womanEasterEgg.cameras = [hudCam];
		womanEasterEgg.setGraphicSize(Std.int(womanEasterEgg.width * 2), Std.int(womanEasterEgg.height * 2));
		womanEasterEgg.updateHitbox();
		womanEasterEgg.screenCenter();
		womanEasterEgg.alpha = 0;
		add(womanEasterEgg);

		retryScreen = new FlxSprite().loadGraphic("assets/images/retryscreen.png", false);
		retryScreen.cameras = [hudCam];
		retryScreen.screenCenter();
		retryScreen.y += 5;
		retryScreen.alpha = 0;
		add(retryScreen);

		var background = new FlxSprite().loadGraphic("assets/images/background.png", false);
		background.setGraphicSize(Std.int(background.width / 3) + 1, Std.int(background.height / 3) + 1); // +1 because single pixel gap on border
		background.screenCenter();
		background.cameras = [gameCam];
		add(background);

		player = new Player();
		player.screenCenter();
		player.y = 251;
		player.cameras = [gameCam];
		add(player);

		var startEnemySpawns = new FlxTimer();
		startEnemySpawns.start(2, function(tmr:FlxTimer)
		{
			SpawnEnemy(tmr);
		});

		// FlxG.sound.play("assets/sounds/playerspawn.wav"); // sound plays immediately after another sound is played rather than on spawn. not sure why. can't fix. rip bozo??
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		enemiesDefeatedText.text = "Killed: " + enemiesDefeated;

		if (player.isDead && FlxG.keys.anyJustPressed(Controls.RETRY))
		{
			FlxG.resetState();
		}

		if (player.isDead && FlxG.keys.anyJustPressed(Controls.EASTEREGG))
		{
			womanEasterEgg.y = FlxG.height;
			womanEasterEgg.alpha = 1;
			womanEasterEgg.velocity.y = -100;
		}

		// if (FlxG.keys.anyPressed([W, UP]))
		// {
		// 	player.y -= 2;
		// }
		// if (FlxG.keys.anyPressed([S, DOWN]))
		// {
		// 	player.y += 2;
		// }
		// trace(player.y);
	}

	function SpawnEnemy(timer:FlxTimer)
	{
		trace("Spawned enemy after " + timer.time + " seconds.");
		var nextSpawnTime:Float = FlxG.random.float(0.5, enemyMaxSpawnTime);
		var nextSpawnSide:Bool = FlxG.random.bool(50);
		var enemySpawnTimer = new FlxTimer().start(nextSpawnTime, function(tmr:FlxTimer)
		{
			// Spawn the enemy
			var enemy:Enemy = new Enemy(player);
			enemy.cameras = [gameCam];
			enemy.y = player.y;
			if (!nextSpawnSide) // Left side
			{
				enemy.x = 210 - enemy.width;
			}
			else // Right side
			{
				enemy.x = 415 + enemy.width;
				enemy.flipX = true;
			}
			add(enemy);
			enemies.add(enemy);

			// Repeat function
			if (!player.isDead)
			{
				SpawnEnemy(tmr);
			}
		});
	}

	public function ShootBullet(lastFacedDirection:Bool) // When the player shoots a bullet (woah!)
	{
		var bullet:Bullet = new Bullet(player);
		bullet.cameras = [gameCam];
		bullet.x = player.x + (player.width / 2);
		bullet.y = player.y + (player.height / 2);
		add(bullet);
		bullets.add(bullet);
		FlxG.sound.play("assets/sounds/shoot.wav");
	}

	public function ShowRetryScreen()
	{
		var retryScreenDelay = new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			retryScreen.alpha = 1;
		});
	}
}
