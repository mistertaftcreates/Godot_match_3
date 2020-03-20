extends Node2D

export (int) var speed
export (int) var left_limit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * delta
	if position.x <= left_limit:
		position.x = 0
