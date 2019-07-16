extends Node

var lives = 3
var max_lives = 5
var time_dict
var next_life_time

# Called when the node enters the scene tree for the first time.
func _ready():
	next_life_time = {
		"hour": 0,
		"minute": 0,
		"second": 0
		}
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

func find_next_life_time():
	get_system_time()
	next_life_time.hour = time_dict.hour
	next_life_time.minute = time_dict.minute + 20
	next_life_time.second = time_dict.second
	if next_life_time.minute >= 60:
		next_life_time.minute = next_life_time.minute%60
		next_life_time.hour += 1
	print(time_dict)
	print(next_life_time)

func convert_time_to_seconds():
	var temp = 0
	temp += (next_life_time.hour - time_dict.hour) * 3600
	temp += (next_life_time.minute - time_dict.minute) * 60
	temp += (next_life_time.second - time_dict.second)
	return temp

func set_life_timer():
	find_next_life_time()
	#var elapsed = next_life_time - time_dict
	return convert_time_to_seconds()