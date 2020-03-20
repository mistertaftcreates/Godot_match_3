extends "res://Scripts/ice.gd"


export var color := "None"

onready var move_tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func move(target):
	move_tween.interpolate_property(self, "position", position, target, .3, 
								   Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	move_tween.start()


func dim():
	var sprite = get_node("Sprite")
	sprite.modulate = Color(1, 1, 1, .5);
