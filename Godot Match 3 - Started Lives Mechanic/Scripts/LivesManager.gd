extends Node

var lives = 3
var max_lives = 5
var time_dict
var next_life_time

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reduce_lives():
	lives -= 1
	if lives < 0:
		lives = 0

func increase_lives():
	lives += 1
	if lives > max_lives:
		lives = max_lives

func lives_available():
	if lives > 0:
		return true
	return false

func get_system_time():
	time_dict = OS.get_time()
	var hour = time_dict.hour
	var minute = time_dict.minute
	var seconds = time_dict.second

func find_next_life_time():
	get_system_time()
	next_life_time = time_dict
	next_life_time.minute += 20
	if next_life_time.minute >= 60:
		next_life_time.minute = next_life_time.minute%60
		next_life_time.hour += 1

func set_life_timer():
	find_next_life_time()
	#var elapsed = next_life_time - time_dict
	var minutes = next_life_time.minute - time_dict.minute
	var seconds = next_life_time.second - time_dict.second
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	return str_elapsed