extends "res://Scripts/BaseMenuPanel.gd"

func _on_Continue_pressed():
	get_tree().paused = false
	slide_out()

func _on_Quit_pressed():
	get_tree().quit()

func _on_bottom_ui_pause_game():
	slide_in()

