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

var move_tween;
var matched = false

func _ready():
	move_tween = get_node("move_tween");
	# Called when the node is added to the scene for the first time.
	# Initialization here

func move(target):
	move_tween.interpolate_property(self, "position", position, target, .3, 
	                               Tween.TRANS_ELASTIC, Tween.EASE_OUT);
	move_tween.start();
	pass;

func make_column_bomb():
	is_column_bomb = true
	$Sprite.texture = column_texture
	$Sprite.modulate = Color(1, 1, 1, 1)

func make_row_bomb():
	is_row_bomb = true
	$Sprite.texture = row_texture
	$Sprite.modulate = Color(1, 1, 1, 1)

func make_adjacent_bomb():
	is_adjacent_bomb = true
	$Sprite.texture = adjacent_texture
	$Sprite.modulate = Color(1, 1, 1, 1)

func make_color_bomb():
	is_color_bomb = true;
	$Sprite.texture = color_bomb_texture
	$Sprite.modulate = Color(1, 1, 1, 1)
	color = "Color"

func dim():
	var sprite = get_node("Sprite")
	sprite.modulate = Color(1, 1, 1, .5);