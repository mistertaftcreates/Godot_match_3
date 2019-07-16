extends Node2D

#Level Stuff
export (int) var level
export (String) var level_to_load
export (bool) var enabled
export (bool) var score_goal_met
var high_score = 10

#Texture Stuff
export (Texture) var blocked_texture
export (Texture) var open_texture
export (Texture) var goal_met
export (Texture) var goal_not_met

onready var level_label = $TextureButton/Label
onready var button = $TextureButton
onready var star = $Sprite

func _ready():
	if GameDataManager.level_info.has(level):
		enabled = GameDataManager.level_info[level]["unlocked"]
		if GameDataManager.level_info[level]["stars unlocked"] == 1:
			score_goal_met = true
		else:
			score_goal_met = false
		high_score = GameDataManager.level_info[level]["high score"]
	else:
		enabled = false
		high_score = 0
	setup()

func setup():
	level_label.text = String(level)
	if enabled:
		button.texture_normal = open_texture
	else:
		button.texture_normal = blocked_texture
	if score_goal_met:
		star.texture = goal_met
	else:
		star.texture = goal_not_met

func _on_TextureButton_pressed():
	if enabled:
		get_parent().emit_signal("level_panel_enter", high_score, level_to_load)
