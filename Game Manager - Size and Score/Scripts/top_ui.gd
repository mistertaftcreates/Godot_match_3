extends TextureRect

onready var score_label = $MarginContainer/HBoxContainer/VBoxContainer/ScoreLabel
onready var counter_label = $MarginContainer/HBoxContainer/CounterLabel
onready var score_bar = $MarginContainer/HBoxContainer/VBoxContainer/TextureProgress
onready var goal_container = $MarginContainer/HBoxContainer/HBoxContainer
export (PackedScene) var goal_prefab

#signal to the Goal holder to know what level we're on
signal notify_of_level

func _ready():
	#emit_signal("notify_of_level", current_level)
	pass

func make_goal(new_max, new_texture, new_value):
	var current = goal_prefab.instance()
	goal_container.add_child(current)
	current.set_goal_values(new_max, new_texture, new_value)

func _on_GoalHolder_create_goal(new_max, new_texture, new_value):
	make_goal(new_max, new_texture, new_value)

func _on_grid_check_goal(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).update_goal_values(goal_type)

func _on_ice_holder_break_ice(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).update_goal_values(goal_type)

func _on_GameManager_set_counter_info(current_counter):
	if !counter_label:
		counter_label = $MarginContainer/HBoxContainer/CounterLabel
	counter_label.text = String(current_counter)

func _on_GameManager_set_score_info(new_max, new_current):
	if !score_bar:
		score_bar = $MarginContainer/HBoxContainer/VBoxContainer/TextureProgress
	if !score_label:
		score_label = $MarginContainer/HBoxContainer/VBoxContainer/ScoreLabel
	score_bar.max_value = new_max
	score_bar.value = new_current
	score_label.text = String(new_current)
