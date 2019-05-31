extends TextureRect

signal pause_game
signal booster

func _on_Pause_pressed():
	emit_signal("pause_game")
	get_tree().paused = true

func _on_Booster1_pressed():
	emit_signal("booster")
