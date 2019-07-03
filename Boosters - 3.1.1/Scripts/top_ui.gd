extends TextureRect

onready var score_label = $MarginContainer/HBoxContainer/VBoxContainer/ScoreLabel
onready var counter_label = $MarginContainer/HBoxContainer/CounterLabel
onready var score_bar = $MarginContainer/HBoxContainer/VBoxContainer/TextureProgress
onready var goal_container = $MarginContainer/HBoxContainer/HBoxContainer
export (PackedScene) var goal_prefab
export (int) var current_level
var current_score = 0
var current_count = 0
var max_counter = 0

#signal to the Goal holder to know what level we're on
signal notify_of_level

func _ready():
	emit_signal("notify_of_level", current_level)
	_on_grid_update_score(current_score)

func _on_grid_update_score(amount_to_change):
	current_score += amount_to_change
	update_score_bar()
	score_label.text = String(current_score)
	if GameDataManager.level_info.has(current_level):
		GameDataManager.level_info[current_level]["high score"] = current_score
	if current_score >= score_bar.max_value:
		GameDataManager.level_info[current_level]["stars unlocked"] = 1

func _on_grid_update_counter(amount_to_change = -1):
	current_count += amount_to_change
	if current_count > max_counter:
		current_count = max_counter
	counter_label.text = String(current_count)

func setup_score_bar(max_score):
	score_bar.max_value = max_score

func update_score_bar():
	score_bar.value = current_score

func make_goal(new_max, new_texture, new_value):
	var current = goal_prefab.instance()
	goal_container.add_child(current)
	current.set_goal_values(new_max, new_texture, new_value)

func _on_grid_setup_max_score(max_score):
	setup_score_bar(max_score)

func _on_GoalHolder_create_goal(new_max, new_texture, new_value):
	make_goal(new_max, new_texture, new_value)

func _on_grid_check_goal(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).update_goal_values(goal_type)

func _on_ice_holder_break_ice(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).update_goal_values(goal_type)

func _on_grid_set_max_counter(new_max_counter):
	max_counter = new_max_counter
