extends Node2D

# board values
var swirl_pieces = []
var width = 8
var height = 10
var swirl = preload("res://Scenes/LicoriceSwirl.tscn")


signal set_board_space


func make_2d_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;

func _on_grid_make_swirl(board_position):
	if swirl_pieces.size() == 0:
		swirl_pieces = make_2d_array()
	var current = swirl.instance()
	add_child(current)
	current.position = Vector2(board_position.x * 64 + 64, -board_position.y * 64 + 800)
	#swirl_pieces[board_position.x][board_position.y] = current
	emit_signal("set_board_space", board_position)


