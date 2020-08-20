extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var player_vars = get_node("/root/Global");
	
	$Replay.visible = true;
	$Title.visible = true;
	$Score.text = 'Votre score est de\n%d' % player_vars.score;
	$Score.visible = true;
	$copyright.visible = true;


func _on_Replay_pressed():
	get_tree().change_scene("res://scene/main.tscn");
	
