extends Area2D
signal hit
signal update_hud(score, bonus)
signal boss


export var speed = 400;
var screen_size;
var sprite_size;

export (PackedScene) var laser;
export (NodePath) var hud;

var shootAuthor = true;
var score = 0;
var bonus = '';

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_size = $Sprite.get_rect().size * scale;
	screen_size = get_viewport_rect().size;
	
	position.y = (screen_size.y - (sprite_size.y / 2)) - 15;
	position.x = (screen_size.x / 2) - (sprite_size.x);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var velocity = Vector2();
	velocity.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))	
	position += velocity.normalized() * speed * delta;
	position.x = clamp(position.x, sprite_size.x/2, screen_size.x - (sprite_size.x));
	
	if(Input.is_action_pressed("ui_accept") && (shootAuthor || bonus == 'unlimited')):
		FireLaser();
		shootAuthor = false;
		$ShootTimer.start();


func _on_Player_body_entered(body):
	if(bonus != 'invacibility'):
		emit_signal("hit");
		$CollisionShape2D.set_deferred('disabled', true);
		print('hit player')
	
func FireLaser():
	var temp_laser = laser.instance();
	get_parent().add_child(temp_laser);
	temp_laser.position.x = position.x;
	temp_laser.position.y = position.y;
	if(bonus == 'laser_big'):
		temp_laser.scale.x = 4;
		temp_laser.scale.y = 4;


func _on_ShootTimer_timeout():
	shootAuthor = true;

func addScore():
	score+=1;
	emit_signal("update_hud", score, bonus);
	
	#if(score % 100 == 0):
	if(score % 100 == 0):
		emit_signal("boss");
	
	var player_vars = get_node("/root/Global");
	player_vars.score = score;
	

func addPowerUp(type):
	$PowerUpTimer.wait_time = 5.0;
	$PowerUpTimer.start();
	bonus = type;
	emit_signal("update_hud", score, bonus);


func _on_PowerUpTimer_timeout():
	bonus = '';
	emit_signal("update_hud", score, bonus);
