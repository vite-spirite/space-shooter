extends Area2D

var powerupType;
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	var powerUpAnim = $AnimationPlayer.get_animation_list();
	powerupType = powerUpAnim[randi() % powerUpAnim.size()];
	$AnimationPlayer.play(powerupType);

func _physics_process(delta):
	position += Vector2(0, 1).normalized() * rand_range(200, 400) * delta;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_powerup_area_entered(area):
	get_node('../Player').addPowerUp(powerupType);
	queue_free()
