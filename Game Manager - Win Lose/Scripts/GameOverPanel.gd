extends "res://Scripts/BaseMenuPanel.gd"

func _on_Quit_Button_pressed():
	get_tree().change_scene("res://Scenes/LevelSelectScene.tscn")


func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_GameManager_game_lost():
	slide_in()
