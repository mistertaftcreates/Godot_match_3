extends TextureRect

signal pause_game
signal booster
signal undo_booster
signal consume_booster

func _on_Pause_pressed():
	emit_signal("pause_game")
	get_tree().paused = true

func _on_Booster1_used():
	emit_signal("booster", $MarginContainer/HBoxContainer/Booster1.type)


func _on_Booster2_used():
	emit_signal("booster", $MarginContainer/HBoxContainer/Booster2.type)


func _on_Booster3_used():
	emit_signal("booster", $MarginContainer/HBoxContainer/Booster3.type)


func _on_GameManager_reset_boosters(booster_type):
	emit_signal("undo_booster", booster_type)

func _on_GameManager_booster_used(booster_type):
	emit_signal("consume_booster", booster_type)
