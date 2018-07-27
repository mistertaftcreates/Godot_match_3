extends Node2D

# Signals
signal make_ice;
signal destroy_ice;
signal make_concrete;
signal destroy_concrete;
signal make_slime;
signal make_lock;

# Board Variables
export (int) var width; 
export (int) var height; 
export (int) var xStart; 
export (int) var yStart; 
export (int) var offset;
export (int) var y_offset;
var all_pieces;

# Modified spaces:
export var blank_spaces = PoolVector2Array();
export var ice_spaces = PoolVector2Array();
export var concrete_spaces = PoolVector2Array();
export var slime_spaces = PoolVector2Array();
export var lock_spaces = PoolVector2Array();

# Timers
onready var find_matches_timer = get_node("find_matches");
onready var refill_timer = get_node("refill_timer");
onready var piece_tweener = get_node("piece_tweener");
var piece = null;
var new_position = Vector2(0,0);

# Piece Stuff
var possible_pieces = [preload("res://Scenes/Yellow Pentagon.tscn"),
preload("res://Scenes/Teal Star.tscn"),
preload("res://Scenes/Red Circle.tscn"),
preload("res://Scenes/Orange Triangle.tscn"),
preload("res://Scenes/Green Diamond.tscn"),
preload("res://Scenes/Blue Cloud.tscn")
]

# Touch Variables
var first_touch;
var final_touch;
var controlling = false;

# Background Tile 
export (PackedScene) var background;

func _ready():

	randomize();
	all_pieces = make_array();
	generate_ice();
	generate_concrete();
	generate_slime();
	setup_board();
	generate_pieces();
	pass

func make_array():
	var matrix = [ ]
	for x in range(width):
		matrix.append([ ]);
		for y in range(height):
			matrix[x].append(0);
	return matrix;
	pass;

func setup_board():
	for i in width:
		for j in height:
			var make_piece = true;
			for k in blank_spaces.size():
				if blank_spaces[k] == Vector2(i,j):
					make_piece = false;
			if(make_piece):
				var b = background.instance();
				add_child(b);
				b.position = Vector2((xStart + (i * offset)), (yStart - (j * offset)));
	pass;

func generate_pieces():
	for i in width:
		for j in height:
			if(!find_in_blank_pieces(i, j) && !find_in_concrete_pieces(i,j) && !find_in_slime_pieces(i,j)):
				var piece_to_use = round(rand_range(0, possible_pieces.size()));
				if piece_to_use == 6:
					piece_to_use = 5;
				var piece = possible_pieces[piece_to_use].instance();
				
				var loops = 0;
				while check_for_matches(i,j, piece.color) && loops < 100:
					piece_to_use = round(rand_range(0, possible_pieces.size()));
					if piece_to_use == 6:
						piece_to_use = 5;
					piece = possible_pieces[piece_to_use].instance();
					loops += 1;
			
				add_child(piece);
				#Add the slide in code . . . 
				piece.position = Vector2(xStart + i * offset, yStart - j * offset - y_offset);
				piece.move_piece(Vector2(0, y_offset));
				#piece.position = Vector2(xStart + i * offset, yStart - j * offset);
				all_pieces[i][j] = piece;
			else:
				all_pieces[i][j] = null;
	pass;

func generate_ice():
	for i in ice_spaces.size():
		emit_signal("make_ice", ice_spaces[i]);
	pass;

func generate_concrete():
	for i in concrete_spaces.size():
		emit_signal("make_concrete", concrete_spaces[i]);
	pass;

func generate_slime():
	for i in slime_spaces.size():
		emit_signal("make_slime", slime_spaces[i]);
	pass;

func generate_locks():
	for i in lock_spaces.size():
		emit_signal("make_lock", lock_spaces[i]);
	pass;

func check_for_matches(column, row, color):
	#Check Left
	if column > 1 && row <= 1:
		if(is_valid_position(column - 1, row) && is_valid_position(column - 2, row)):
			if(all_pieces[column - 1][row].color == color):
				if(all_pieces[column - 2][row].color == color):
					return true;
	#Check right
	elif column <= 1 && row > 1:
		if(is_valid_position(column, row - 1) && is_valid_position(column, row - 2)):
			if(all_pieces[column][row - 1].color == color):
				if(all_pieces[column][row - 2].color == color):
					return true;
	#Check Both
	elif column > 1 && row > 1:
		if(is_valid_position(column - 1, row) && is_valid_position(column - 2, row)):
			if(is_valid_position(column, row - 1) && is_valid_position(column, row - 2)):
				if((all_pieces[column - 1][row].color == color
				&& all_pieces[column - 2][row].color == color)
				|| (all_pieces[column][row -1].color == color
				&& (all_pieces[column][row - 2].color == color))):
					return true;
	return false;
	pass;

func pixel_to_grid(touch_position):
	var column = round((touch_position.x - xStart)/offset);
	var row = round((touch_position.y - yStart)/-offset);
	return Vector2(column, row);
	pass;

func is_in_grid(touch_position):
	if(touch_position.x >= 0 && touch_position.x < width):
		if(touch_position.y >= 0 && touch_position.y < height):
			return true;
	return false;
	pass;

func find_in_blank_pieces(column, row):
	var is_blank = false;
	for k in blank_spaces.size():
		if blank_spaces[k] == Vector2(column,row):
			is_blank = true;
	return is_blank;
	
	pass;

func find_in_ice_pieces(column, row):
	var is_ice = false;
	for i in ice_spaces.size():
		if ice_spaces[i] == Vector2(column, row):
			is_ice = true;
	return is_ice;
	pass;

func find_in_concrete_pieces(column, row):
	var is_concrete = false;
	for i in concrete_spaces.size():
		if concrete_spaces[i] == Vector2(column, row):
			is_concrete = true;
	return is_concrete;
	pass;

func find_in_slime_pieces(column, row):
	var is_slime = false;
	for i in slime_spaces.size():
		if(slime_spaces[i] == Vector2(column, row)):
			is_slime = true;
	return is_slime;
	pass;

func find_in_lock_pieces(column, row):
	var is_lock = false;
	for i in lock_spaces.size():
		if(lock_spaces[i] == Vector2(column, row)):
			is_lock = true;
	return is_lock;
	pass;

func non_refill_spaces(column, row):
	var non_refill = false;
	if(find_in_slime_pieces(column, row) || find_in_blank_pieces(column, row) || find_in_slime_pieces(column, row) 
	|| find_in_concrete_pieces(column, row)):
		non_refill = true;
	return non_refill;
	pass;

func non_control_spaces(column, row):
	var non_control = false;
	if(find_in_slime_pieces(column, row) || find_in_blank_pieces(column, row) || find_in_slime_pieces(column, row)
	|| find_in_concrete_pieces(column, row) || find_in_lock_pieces(column, row)):
		non_control = true;
	return non_control;
	pass;

func is_in_board(column, row):
	if(column >= 0 && column < width):
		if(row >= 0 && row < height):
			return true;
	return false;
	pass;

func is_valid_position(column, row):
	if(is_in_board(column, row)):
		if(all_pieces[column][row] != null):
			if(!find_in_blank_pieces(column, row)):
				if(!find_in_concrete_pieces(column, row)):
					if(!find_in_slime_pieces(column, row)):
						return true;
	return false;
	pass;

func swap_pieces(column, row, direction):
	if(!find_in_blank_pieces(column, row) && !find_in_concrete_pieces(column,row) && !find_in_slime_pieces(column,row)):
		var first_piece = all_pieces[column][row];
		if(!find_in_blank_pieces(column + direction.x, row + direction.y) && !find_in_concrete_pieces(column + direction.x,row + direction.y) && !find_in_slime_pieces(column + direction.x,row + direction.y)):
			var other_piece = all_pieces[column + direction.x][row + direction.y];
			all_pieces[column + direction.x][row + direction.y] = first_piece;
			all_pieces[column][row] = other_piece;
			first_piece.move_piece(Vector2(direction.x * offset, direction.y * -offset));
			other_piece.move_piece(Vector2(direction.x * -offset, direction.y * offset));
			find_matches_timer.start();
	pass;

func touch_difference(first_touch, final_touch):
	var difference = final_touch - first_touch;
	if(abs(difference.x) > abs(difference.y)):
		if(difference.x > 0):
			swap_pieces(first_touch.x, first_touch.y, Vector2(1, 0));
		elif(difference.x < 0):
			swap_pieces(first_touch.x, first_touch.y, Vector2(-1, 0));
	elif(abs(difference.y) > abs(difference.x)):
		if(difference.y > 0):
			swap_pieces(first_touch.x, first_touch.y, Vector2(0, 1));
		elif(difference.y < 0):
			swap_pieces(first_touch.x, first_touch.y, Vector2(0, -1));
	pass;

func _process(delta):
	touch_input();
	pass

func find_matches():
	for i in width:
		for j in height:
			if(is_valid_position(i, j)):
				#Check left and right
				if i > 0 && i < width - 1:
					if(is_valid_position(i - 1, j) && is_valid_position(i + 1, j)):
						var color = all_pieces[i][j].color;
						if (all_pieces[i - 1][j].color == color 
						&& all_pieces[i + 1][j].color == color):
							all_pieces[i - 1][j].is_matched = true;
							all_pieces[i + 1][j].is_matched = true;
							all_pieces[i][j].is_matched = true;
				if j > 0 && j < height - 1:
					if(is_valid_position(i, j - 1) && is_valid_position(i, j + 1)):
						var color = all_pieces[i][j].color;
						if (all_pieces[i][j - 1].color == color 
						&& all_pieces[i][j + 1].color == color):
							all_pieces[i][j - 1].is_matched = true;
							all_pieces[i][j + 1].is_matched = true;
							all_pieces[i][j].is_matched = true;
	destroy_matched();
	pass;

func destroy_matched():
	for i in width:
		for j in height:
			if(is_valid_position(i,j)):
				if(all_pieces[i][j].is_matched):
					all_pieces[i][j].queue_free();
					all_pieces[i][j] = null;
					if(find_in_ice_pieces(i,j)):
						destroy_ice(Vector2(i,j));
					destroy_concrete(i,j);
	collapse_columns();
	pass;

func destroy_ice(board_position):
	emit_signal("destroy_ice", board_position);
	pass;

func destroy_concrete(column, row):
	if is_in_board(column + 1, row):
		if(find_in_concrete_pieces(column + 1, row)):
			emit_signal("destroy_concrete", Vector2(column + 1, row));
	if is_in_board(column - 1, row):
		if(find_in_concrete_pieces(column - 1, row)):
			emit_signal("destroy_concrete", Vector2(column - 1, row));
	if is_in_board(column + 1, row):
		if(find_in_concrete_pieces(column, row + 1)):
			emit_signal("destroy_concrete", Vector2(column, row + 1));
	if is_in_board(column + 1, row):
		if(find_in_concrete_pieces(column, row - 1)):
			emit_signal("destroy_concrete", Vector2(column, row - 1));
	pass;

func collapse_columns():
	for i in width:
		for j in height:
			if(all_pieces[i][j] == null && !find_in_blank_pieces(i,j) 
			&& !find_in_concrete_pieces(i,j) && !find_in_slime_pieces(i,j)):
				for k in range(j + 1, height):
					if(all_pieces[i][k] != null):
						all_pieces[i][j] = all_pieces[i][k];
						#all_pieces[i][k].position = Vector2(i * offset + xStart, -j * offset + yStart);
						all_pieces[i][k].move_piece(Vector2(0, (k-j) * offset));
						all_pieces[i][k] = null;
						break;
	refill_timer.start();
	pass;

func refill_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null && !find_in_blank_pieces(i,j) && !find_in_concrete_pieces(i,j) && !find_in_slime_pieces(i,j):
				var piece_to_use = round(rand_range(0, possible_pieces.size()));
				if piece_to_use == 6:
					piece_to_use = 5;
				var piece = possible_pieces[piece_to_use].instance();
				
				var loops = 0;
				while check_for_matches(i,j, piece.color) && loops < 100:
					piece_to_use = round(rand_range(0, possible_pieces.size()));
					if piece_to_use == 6:
						piece_to_use = 5;
					piece = possible_pieces[piece_to_use].instance();
					loops += 1;
				
				add_child(piece);
				#piece.position = Vector2(xStart + i * offset, yStart - j * offset);
				piece.position = Vector2(xStart + i * offset, yStart - j * offset - y_offset);
				piece.move_piece(Vector2(0, y_offset));
				all_pieces[i][j] = piece;
	#check for new matches
	for i in width:
		for j in height:
			if(all_pieces[i][j] != null):
				if(check_for_matches(i,j,all_pieces[i][j].color)):
					find_matches_timer.start();
					return;
	pass;

func touch_input():
	if(Input.is_action_just_pressed("ui_touch")):
		if(is_in_grid(pixel_to_grid(get_global_mouse_position()))):
			controlling = true;
			first_touch = pixel_to_grid(get_global_mouse_position());
	if(Input.is_action_just_released("ui_touch") && controlling):
		if(is_in_grid(pixel_to_grid(get_global_mouse_position()))):
			controlling = false;
			final_touch = pixel_to_grid(get_global_mouse_position());
			touch_difference(first_touch, final_touch);
	pass;

func move_piece(piece, position_change):
	piece_tweener.interpolate_property(piece, "transform/position", piece.position, 
        piece.position + position_change, 
        .3, Tween.TRANS_SINE, Tween.EASE_OUT_IN);
	piece_tweener.start();
	pass;

func _on_find_matches_timeout():
	find_matches();
	pass

func _on_refill_timer_timeout():
	refill_columns();
	pass 

func _on_concrete_holder_concrete_clear(board_position):
	# let the all_pieces grid know that the position is now clear
	var index = 0;
	for i in concrete_spaces.size():
		if(concrete_spaces[i] == board_position):
			concrete_spaces.remove(i);
	pass 
