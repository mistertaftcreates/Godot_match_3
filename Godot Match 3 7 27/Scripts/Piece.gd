extends Node2D

export (String) var color;
onready var effect = get_node("movement_tween");
var is_matched;
var target_position = Vector2(0,0);

func _ready():

	pass

func _process(delta):
	
	pass

func move_piece(change):
	target_position = position + change;
	effect.interpolate_property(self, "position",
                position, target_position, .4,
                Tween.TRANS_ELASTIC, Tween.EASE_OUT);
	effect.start();
	pass;


func _on_movement_tween_tween_completed(object, key):
	
	pass # replace with function body
