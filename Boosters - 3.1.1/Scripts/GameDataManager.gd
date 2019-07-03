extends Node

var level_info = {}
var default_level_info = {
	1:{
		"unlocked": true,
		"high score": 0,
		"stars unlocked": 0
		}
	}
onready var path = "user://save.dat"

func _ready():
	#level_info = load_data()
	level_info = default_level_info

func save_data():
	var file = File.new()
	var err = file.open(path, File.WRITE)
	if err != OK:
		print ("something went wrong")
		return
	file.store_var(level_info)
	file.close()

func load_data():
	var file = File.new()
	var err = file.open(path, File.READ)
	if err != OK:
		return default_level_info
		print("something happened")
	var read = {}
	read = file.get_var()
	return read
