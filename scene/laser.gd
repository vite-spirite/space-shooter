extends Area2D

export var speed = 200;
var isStopped = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle");

func _physics_process(delta):
	if(!isStopped):
		position += Vector2(0, -1).normalized() * speed * delta;

func _on_VisibilityNotifier2D_screen_exited():
	print('deleted');
	queue_free();


func _on_Laser_body_entered(body):
	#if(body.name == "enemy"):
	isStopped = true;
	$AnimationPlayer.play("hit");
	body.hitLaser();
	get_node('../Player').addScore();


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == 'hit'):
		queue_free();
