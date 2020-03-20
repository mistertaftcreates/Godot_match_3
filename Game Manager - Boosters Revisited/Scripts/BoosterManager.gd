extends HBoxContainer

"""
This script exists to manage the booster buttons.  It 
reads the booster types for the level from the booster 
info script and sets the buttons to have a corresponding 
texture to their type, or no texture if they don't have 
a type.
"""

func _ready():
	BoosterInfo.booster_info[1] = "Add To Counter"
	activate_booster_buttons()

func activate_booster_buttons():
	for i in range(1, get_child_count()):
		if get_child(i).is_in_group("Boosters"):
			if BoosterInfo.booster_info[i] == "":
				get_child(i).check_active(false, null)
			else:
				get_child(i).check_active(true, BoosterInfo.booster_info[i])

