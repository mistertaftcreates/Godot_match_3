extends "res://Scripts/BaseMenuPanel.gd"

func _on_ContinueButton_pressed():
	get_tree().reload_current_scene()

func _on_GoalHolder_game_won():
	slide_in()
