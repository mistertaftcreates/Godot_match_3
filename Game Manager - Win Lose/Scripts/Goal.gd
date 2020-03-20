extends Node

#Goal information
export (bool) var is_piece_goal

export (Texture) var goal_texture
export (int) var max_needed
export (String) var goal_string
var number_collected = 0
var goal_met = false

func check_goal(goal_type, amount_collected = 1):
	if goal_type == goal_string:
		update_goal(amount_collected)

func update_goal(amount_collected):
	if is_piece_goal:
		if number_collected < max_needed:
			number_collected += amount_collected;
	else:
		number_collected = amount_collected
	if number_collected >= max_needed:
		if !goal_met:
			goal_met = true
