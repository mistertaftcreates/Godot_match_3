extends TextureRect

signal pause_game
signal booster

func _on_Pause_pressed():
	emit_signal("pause_game")
	get_tree().paused = true

func _on_Booster1_pressed():
	emit_signal("booster", $MarginContainer/HBoxContainer/Booster1.type)

func _on_Booster2_pressed():
	emit_signal("booster", $MarginContainer/HBoxContainer/Booster2.type)

func _on_Booster3_pressed():
	emit_signal("booster", $MarginContainer/HBoxContainer/Booster3.type)
