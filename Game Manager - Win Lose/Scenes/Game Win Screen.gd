extends "res://Scripts/BaseMenuPanel.gd"

var is_out = false

func _on_ContinueButton_pressed():
	get_tree().change_scene("res://Scenes/LevelSelectScene.tscn")

func _on_GameManager_game_won():
	if is_out == false:
		is_out = true
		slide_in()
