extends RigidBody2D

export (PackedScene) var explosion;
export (NodePath) var main;

export var min_speed = 200;
export var max_speed = 400;

var sprite_size;
var screen_size;


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_size = $Sprite.get_rect().size;
	screen_size = get_viewport().size;
	
	$AnimationPlayer.play("small_enemy");
	position.x = clamp(position.x, sprite_size.x/2, screen_size.x-(sprite_size.x/2));
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free();


func hitLaser():
	$CollisionShape2D.set_deferred('disabled', true);
	for n in 3:
		var tmp_explosion = explosion.instance();
		get_tree().get_root().call_deferred("add_child", tmp_explosion);
		tmp_explosion.position = Vector2(rand_range(position.x-5, position.x+5), rand_range(position.y-5, position.y + 5));
		tmp_explosion.playAnimation();
	queue_free();
