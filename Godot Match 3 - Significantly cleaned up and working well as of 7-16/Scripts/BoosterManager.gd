extends HBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	activate_booster_buttons()

func activate_booster_buttons():
	for i in range(1, get_child_count()):
		if get_child(i).is_in_group("Boosters"):
			if !BoosterInfo.booster_info.has(i):
				get_child(i).check_active(false, null, 1)
			else:
				get_child(i).check_active(true, BoosterInfo.booster_info[i]["type"], BoosterInfo.booster_info[i]["number"])

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
