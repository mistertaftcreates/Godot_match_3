extends "res://Scripts/BaseMenuPanel.gd"

func _on_Quit_Button_pressed():
	get_tree().change_scene("res://Scenes/Game Menu.tscn")
	pass # replace with function body

func _on_Restart_pressed():
	get_tree().reload_current_scene()
	pass # replace with function body

func _on_grid_game_over():
	slide_in()
	pass # replace with function body
