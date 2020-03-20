extends Node2D

export (String) var color;
export (Texture) var row_texture
export (Texture) var column_texture
export (Texture) var adjacent_texture
export (Texture) var color_bomb_texture

var is_row_bomb = false
var is_column_bomb = false
var is_adjacent_bomb = false
var is_color_bomb = false
export var is_matchable := true

var move_tween;
var matched = false

onready var sprite = $Sprite

func _ready():
	move_tween = get_node("move_tween")


func move(target):
	move_tween.interpolate_property(self, "position", position, target, .3, 
	                               Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	move_tween.start()


func change_texture_and_modulate(new_texture, new_color):
	sprite.texture = new_texture
	sprite.modulate = new_color


func make_column_bomb():
	is_column_bomb = true
	change_texture_and_modulate(column_texture, Color(1, 1, 1, 1))


func make_row_bomb():
	is_row_bomb = true
	change_texture_and_modulate(row_texture, Color(1, 1, 1, 1))


func make_adjacent_bomb():
	is_adjacent_bomb = true
	change_texture_and_modulate(adjacent_texture, Color(1, 1, 1, 1))


func make_color_bomb():
	is_color_bomb = true;
	change_texture_and_modulate(color_bomb_texture, Color(1, 1, 1, 1))
	color = "Color"


func match_and_dim():
	if is_matchable:
		matched = true
		sprite.modulate = Color(1, 1, 1, .5)