extends "res://Scripts/BaseMenuPanel.gd"

export (String) var main_level_name

func _on_Continue_pressed():
	get_tree().paused = false
	slide_out()

func _on_Quit_pressed():
	get_tree().paused = false
	get_tree().change_scene(main_level_name)

func _on_bottom_ui_pause_game():
	slide_in()

