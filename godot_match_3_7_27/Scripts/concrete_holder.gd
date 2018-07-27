extends Node2D

export (PackedScene) var concrete_block;

var all_concrete = [];

signal concrete_clear;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func make_array():
	var matrix = [ ]
	for x in range(8):
		matrix.append([ ]);
		for y in range(10):
			matrix[x].append(0);
	return matrix;
	pass;

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_grid_make_concrete(board_position):
	if(all_concrete.size() == 0):
		all_concrete = make_array();
	var c = concrete_block.instance();
	add_child(c);
	c.position = Vector2(board_position.x * 64 + 64, -board_position.y * 64 + 832);
	all_concrete[board_position.x][board_position.y] = c;
	pass 


func _on_grid_destroy_concrete(board_position):
	if(all_concrete[board_position.x][board_position.y] != null):
		all_concrete[board_position.x][board_position.y].queue_free();
		all_concrete[board_position.x][board_position.y] = null;
		emit_signal("concrete_clear", board_position);
	pass # replace with function body
