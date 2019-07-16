extends "res://Scripts/BaseMenuPanel.gd"

onready var high_score_label = $"MarginContainer/Graphic and Buttons/Graphic/HighScoreLabel"
var high_score
var level_to_load = ""

func setup(high_score, new_level):
	high_score_label = String(high_score)
	level_to_load = new_level

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_GoButton_pressed():
	get_tree().change_scene(level_to_load)

func _on_BackButton_pressed():
	slide_out()

func _on_LevelBackdrop_level_panel_enter(new_high_score, new_level):
	setup(new_high_score, new_level)
	slide_in()
