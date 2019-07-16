extends "res://Scripts/BaseMenuPanel.gd"

onready var score_label = $MarginContainer/TextureRect/VBoxContainer/ScoreLabel
var is_out = false

func _on_ContinueButton_pressed():
	get_tree().change_scene("res://Scenes/LevelSelectScene.tscn")

func _on_GoalHolder_game_won():
	if is_out == false:
		is_out = true
		slide_in()

func _on_GameManager_game_won(current_score):
	if is_out == false:
		is_out = true
		slide_in()
		score_label.text = String(current_score)
