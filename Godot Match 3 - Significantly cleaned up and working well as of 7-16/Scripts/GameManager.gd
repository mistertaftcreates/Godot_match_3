extends Node2D

enum {play, win, lose, pause}

var state = play
var grid_stable = false
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

# Booster Stuff
var current_booster_type = ""

# Signals
signal set_dimensions
signal set_score_info
signal set_counter_info
signal create_goal
signal check_goal
signal game_won
signal game_lost
signal color_bomb
signal destroy_piece
signal reset_boosters
signal booster_used

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()

func _process(delta):
	if Input.is_action_just_pressed("ui_touch") and current_booster_type != "":
		booster_input()

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
	elif !check_win_lose() and current_counter == 0 and grid_stable:
		if state == play:
			game_lose()

func check_win_lose():
	for i in goal_container.get_child_count():
		if !goal_container.get_child(i).goal_met:
			return false
	if grid_stable:
		return true
	return false

func game_win():
	state = win
	emit_signal("game_won", current_score)
	var temp
	if current_score > max_score:
		temp = 1
	else:
		temp = 0
	GameDataManager.level_info[level] = {
		"unlocked": true,
		"high score": current_score,
		"stars unlocked": temp
		}
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

func make_booster_active(booster_type):
	current_booster_type = booster_type

func in_booster_zone(pixel_coord):
	if pixel_coord.x > 20 and pixel_coord.x < 556:
		if pixel_coord.y > 300 and pixel_coord.y < 800:
			return true
	return false

func booster_input():
	if Input.is_action_just_pressed("ui_touch"):
		if in_booster_zone(get_global_mouse_position()):
			if current_booster_type == "Color Bomb":
				emit_signal("color_bomb", get_global_mouse_position())
			elif current_booster_type == "Destroy Piece":
				emit_signal("destroy_piece", get_global_mouse_position())
				pass
			elif current_booster_type == "Add To Counter":
				var temp = get_global_mouse_position()
				if temp.x > 20 and temp.x < 556:
					if temp.y > 200 and temp.y < 1000:
						current_counter += 10
						if current_counter > max_counter:
							current_counter = max_counter
						emit_signal("set_counter_info", current_counter)
						current_booster_type = ""
			emit_signal("booster_used", current_booster_type)
		else:
			emit_signal("reset_boosters", current_booster_type)





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

func _on_bottom_ui_booster(booster_type):
	if current_booster_type == "":
		make_booster_active(booster_type)
	else:
		current_booster_type = ""

func _on_grid_broadcast_state(grid_state):
	grid_stable = grid_state

func _on_grid_check_win():
	if check_win_lose():
		game_win()
