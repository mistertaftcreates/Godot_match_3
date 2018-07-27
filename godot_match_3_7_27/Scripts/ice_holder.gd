extends Node2D

export (PackedScene) var ice_block;
var all_ice = [];

func _ready():
	#all_ice = make_array();
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



func _on_grid_make_ice(board_position):
	if(all_ice.size() == 0):
		all_ice = make_array();
	var i = ice_block.instance();
	add_child(i);
	i.position = Vector2(board_position.x * 64 + 64, -board_position.y * 64 + 832);
	all_ice[board_position.x][board_position.y] = i;
	pass


func _on_grid_destroy_ice(board_position):
	if(all_ice[board_position.x][board_position.y] != null):
		all_ice[board_position.x][board_position.y].queue_free();
		all_ice[board_position.x][board_position.y] = null;
	pass 
