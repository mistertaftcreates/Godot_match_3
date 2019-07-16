extends Node2D

""" 
Let's make this a bit more easy to use
"""

# board values
var contents = []
var width = 8
var height = 10
export (String) var obstacle
export (bool) var damage_under
export (bool) var damage_adjacent
export (String) var value

signal destroy_piece

func _ready():
	pass

func make_2d_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;

func _on_grid_make_obstacle(board_position, check_value):
	if check_value == value:
		if contents.size() == 0:
			contents = make_2d_array()
		var current = load(obstacle).instance()
		add_child(current)
		current.position = Vector2(board_position.x * 64 + 64, -board_position.y * 64 + 800)
		contents[board_position.x][board_position.y] = current

func _on_grid_damage_obstacle(board_position, check_value):
	if check_value == value:
		if contents.size() != 0:
			if contents[board_position.x][board_position.y]:
				contents[board_position.x][board_position.y].take_damage(1)
				if contents[board_position.x][board_position.y].health <= 0:
					contents[board_position.x][board_position.y].queue_free()
					contents[board_position.x][board_position.y] = null
					emit_signal("destroy_piece", board_position)
