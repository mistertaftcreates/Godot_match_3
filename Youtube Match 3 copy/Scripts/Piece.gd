extends Node2D

export (String) var color;
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

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func dim():
	var sprite = get_node("Sprite")
	sprite.modulate = Color(1, 1, 1, .5);