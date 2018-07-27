extends Node2D

export (PackedScene) var slime_block;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_grid_make_slime(board_position):
	var s = slime_block.instance();
	add_child(s);
	s.position = Vector2(board_position.x * 64 + 64, -board_position.y * 64 + 832);
	pass 
