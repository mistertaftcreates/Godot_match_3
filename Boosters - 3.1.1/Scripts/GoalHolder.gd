extends Node

signal create_goal
signal game_won

var current_level = 0

func _ready():
	create_goals()

func create_goals():
	for i in get_child_count():
		var current = get_child(i)
		emit_signal("create_goal", current.max_needed, current.goal_texture, current.goal_string) 

func check_goals(goal_type):
	for i in get_child_count():
		get_child(i).check_goal(goal_type)
	check_game_win()

func check_game_win():
	if goals_met():
		emit_signal("game_won")
		GameDataManager.level_info[current_level + 1] = {
			"unlocked": true,
			"high score": 0,
			"stars unlocked": 0
		}

func goals_met():
	for i in get_child_count():
		if !get_child(i).goal_met:
			return false
	return true

func _on_grid_check_goal(goal_type):
	check_goals(goal_type)

func _on_ice_holder_break_ice(goal_type):
	check_goals(goal_type)

func _on_top_ui_notify_of_level(new_level):
	current_level = new_level
	print(current_level)
