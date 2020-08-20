extends CanvasLayer

func _ready():
	updateHUD(0, '');


func updateHUD(score, bonus):
	$Scored.text = 'Score: %d' % score;
	if(bonus == 'invincibility'):
		$ActiveBonus.text = 'Bonus: Invincibilité.';
	elif(bonus == 'laser_big'):
		$ActiveBonus.text = 'Bonus: Arme améliorer.';
	elif(bonus == 'unlimited'):
		$ActiveBonus.text = 'Bonus: Cadance améliorer.';
	else:
		$ActiveBonus.text = 'Bonus: Aucun.';


func _on_Player_update_hud(score, bonus):
	updateHUD(score, bonus);
