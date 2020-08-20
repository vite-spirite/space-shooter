extends RigidBody2D
signal death;

export (PackedScene) var explosion;
export (PackedScene) var enemy;
export (NodePath) var main;

export var min_speed = 200;
export var max_speed = 400;

var sprite_size;
var screen_size;
var life = 100;

var vectorx = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_size = $Sprite.get_rect().size;
	screen_size = get_viewport().size;
	
	$AnimationPlayer.play("idle");
	position.x = clamp(position.x, sprite_size.x/2, screen_size.x-(sprite_size.x/2));
	position.y = sprite_size.y + 5;
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func hitLaser():
	for n in 3:
		var tmp_explosion = explosion.instance();
		get_tree().get_root().call_deferred("add_child", tmp_explosion);
		tmp_explosion.position = Vector2(rand_range(position.x-5, position.x+5), rand_range(position.y-5, position.y + 5));
		tmp_explosion.playAnimation();
	
	life -= 1;
	
	$ColorTimer.wait_time = 0.5;
	$ColorTimer.start();
	
	$Sprite.modulate = Color(255, 0, 0, 255);
	
	if(life <= 0):
		emit_signal("death");
		for n in 15:
			var tmp_explosion = explosion.instance();
			get_tree().get_root().call_deferred("add_child", tmp_explosion);
			tmp_explosion.position = Vector2(rand_range(position.x-5, position.x+5), rand_range(position.y-5, position.y + 5));
			tmp_explosion.playAnimation();
		queue_free();


func _on_ColorTimer_timeout():
	$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0);

func _physics_process(delta):
	if(vectorx == 1):
		if(position.x + 1 > screen_size.x-sprite_size.x):
			vectorx = -1;
		else:
			position += Vector2(1, 0).normalized() * 200 * delta;
	else:
		if(position.x - 1 < sprite_size.x):
			vectorx = 1;
		else:
			position += Vector2(-1, 0).normalized() * 200 * delta;
	
	$CollisionShape2D.position = position;
	if(vectorx == 1):
		$CollisionShape2D.position.y += 10.091;
	else:
		$CollisionShape2D.position.y += -10.091;


func _on_SpawnEnemy_timeout():
	var mob = enemy.instance();
	get_parent().add_child(mob);
	mob.position = position;
	mob.linear_velocity = Vector2(0, mob.max_speed);
