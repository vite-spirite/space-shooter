extends Node2D


export (PackedScene) var Mob;
export (PackedScene) var boss;
export (PackedScene) var PowerUp;

var playing_time = 0.0;
var isBoss = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	initPowerupTimer();
	
	var player_vars = get_node("/root/Global");
	player_vars.score = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayingTimer_timeout():
	playing_time += 0.01;


func _on_SpawnMobTimer_timeout():
	if(isBoss == false):
		if(1.0-playing_time > 0):
			$SpawnMobTimer.wait_time = 1.0-playing_time;
			$SpawnMobTimer.start();
		else:
			$SpawnMobTimer.wait_time = 0.1;
			$SpawnMobTimer.start();
		
		spawnMob();
	else:
		var Boss = boss.instance();
		add_child(Boss);
		Boss.connect('death', self, 'on_Boss_death');
		
	
func spawnMob():
	$Path2D/PathFollow2D.offset = randi();
	var mob = Mob.instance();
	add_child(mob);
	mob.position = $Path2D/PathFollow2D.position;
	mob.linear_velocity = Vector2(0, rand_range(mob.min_speed, mob.max_speed));
	
func initPowerupTimer():
	$PowerupTimer.wait_time = rand_range(5.0, 15.0);
	$PowerupTimer.start();


func _on_PowerupTimer_timeout():
	$Path2D/PathFollow2D.offset = randi();
	var powerup = PowerUp.instance();
	add_child(powerup);
	powerup.position = $Path2D/PathFollow2D.position;
	initPowerupTimer();


func _on_Player_boss():
	isBoss = true;

func on_Boss_death():
	isBoss = false;
	spawnMob();
	$SpawnMobTimer.wait_time = 1.0-playing_time;
	$SpawnMobTimer.start();


func _on_Player_hit():
	get_tree().change_scene("res://scene/GameOver.tscn");


func _on_Replay_pressed():
	get_tree().reload_current_scene();
