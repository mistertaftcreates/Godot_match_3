extends Node

enum {play, win, lose, pause}

var state = play
# Board Variables
export (int) var width
export (int) var height

# Level Variables
export (int) var level
export (bool) var is_moves
export (int) var max_counter
var current_counter

# Score Variables
var current_high_score
var current_score
export (int) var max_score
export (int) var points_per_piece

# Goal Variables
onready var goal_container = $Goals

# Signals
signal set_dimensions
signal set_score_info
signal set_counter_info
signal create_goal
signal check_goal
signal game_won
signal game_lost

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()

func setup():
	if !is_moves:
		$MoveTimer.start()
	current_counter = max_counter
	#Set the score to zero to start
	current_score = 0
	# Check for an existing high score, and store in memory
	if GameDataManager.level_info.has(level):
		if GameDataManager.level_info[level].has("high score"):
			current_high_score = GameDataManager.level_info[level]["high score"]
	emit_signal("set_score_info", max_score, current_score)
	emit_signal("set_dimensions", width, height)
	emit_signal("set_counter_info", current_counter)
	create_goals()

func create_goals():
	for i in goal_container.get_child_count():
		var current = goal_container.get_child(i)
		emit_signal("create_goal", current.max_needed, current.goal_texture, current.goal_string) 

func check_goals(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).check_goal(goal_type)
	emit_signal("check_goal", goal_type)
	if check_win_lose():
		game_win()
	elif !check_win_lose() and current_counter == 0:
		if state == play:
			game_lose()

func check_win_lose():
	for i in goal_container.get_child_count():
		print(goal_container.get_child(i).number_collected)
		if !goal_container.get_child(i).goal_met:
			return false
	return true

func game_win():
	state = win
	emit_signal("game_won")
	GameDataManager.level_info[level + 1] = {
		"unlocked": true,
		"high score": 0,
		"stars unlocked": 0
	}
	if !is_moves:
		$MoveTimer.stop()

func game_lose():
	state = lose
	emit_signal("game_lost")
	LivesManager.reduce_lives()

# Signal Hookups
func _on_grid_update_score(streak_value):
	current_score += streak_value * points_per_piece
	emit_signal("set_score_info", max_score, current_score)

func _on_grid_update_counter():
	if is_moves:
		current_counter -= 1
		if current_counter < 0:
			current_counter = 0
		emit_signal("set_counter_info", current_counter)
		if !check_win_lose() and current_counter == 0:
			if state == play:
				game_lose()

func _on_MoveTimer_timeout():
	if !is_moves:
		current_counter -= 1
		if current_counter < 0:
			current_counter = 0
		emit_signal("set_counter_info", current_counter)
		if !check_win_lose() and current_counter == 0:
			if state == play:
				game_lose()

func _on_grid_check_goal(goal_type):
	check_goals(goal_type)

func _on_ice_holder_break_ice(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).update_goal_values(goal_type)
