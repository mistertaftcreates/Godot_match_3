extends Node2D

# State Machine
enum {wait, move}
var state

# Grid Variables
export (int) var width;
export (int) var height;
export (int) var x_start;
export (int) var y_start;
export (int) var offset;
export (int) var y_offset;

# Obstacle Stuff
export (PoolVector2Array) var empty_spaces
export (PoolVector2Array) var ice_spaces
export (PoolVector2Array) var lock_pieces
export (PoolVector2Array) var concrete_pieces
export (PoolVector2Array) var slime_pieces
var slime_damaged = false

# Obstacle Signals
signal make_ice
signal damage_ice
signal make_locks
signal damage_locks
signal make_concrete
signal damage_concrete
signal make_slime
signal damage_slime

# The piece array
var possible_pieces = [
preload("res://Scenes/yellow_piece.tscn"),
preload("res://Scenes/blue_piece.tscn"),
preload("res://Scenes/pink_piece.tscn"),
preload("res://Scenes/orange_piece.tscn"),
preload("res://Scenes/green_piece.tscn"),
preload("res://Scenes/light_green_piece.tscn")
];

# The current pieces in the scene
var all_pieces = [];

# Swap Back Variables
var piece_one = null
var piece_two = null
var last_place = Vector2(0,0)
var last_direction = Vector2(0,0)
var move_checked = false

# Touch Variables
var first_touch = Vector2(0, 0);
var final_touch = Vector2(0, 0);
var controlling = false;

func _ready():
	state = move
	randomize();
	all_pieces = make_2d_array();
	spawn_pieces();
	spawn_ice()
	spawn_locks()
	spawn_concrete()
	spawn_slime()

func restricted_movement(place):
	# Check the empty pieces
	for i in empty_spaces.size():
		if empty_spaces[i] == place:
			return true
	for i in concrete_pieces.size():
		if concrete_pieces[i] == place:
			return true
	for i in slime_pieces.size():
		if slime_pieces[i] == place:
			return true
	return false

func is_in_locks(place):
	for i in lock_pieces.size():
		if lock_pieces[i] == place:
			return true
	return false

func is_in_concrete(place):
	for i in concrete_pieces.size():
		if concrete_pieces[i] == place:
			return true
	return false

func is_in_slime(place):
	for i in slime_pieces.size():
		if slime_pieces[i] == place:
			return true
	return false

func make_2d_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;

func spawn_pieces():
	for i in width:
		for j in height:
			if !restricted_movement(Vector2(i,j)):
				#choose a random number and store it
				var rand = floor(rand_range(0, possible_pieces.size()));
				var piece = possible_pieces[rand].instance();
				var loops = 0;
				while(match_at(i, j, piece.color) && loops < 100):
					rand = floor(rand_range(0, possible_pieces.size()));
					loops += 1;
					piece = possible_pieces[rand].instance();
				# Instance that piece from the array
				
				add_child(piece);
				piece.position = grid_to_pixel(i, j);
				all_pieces[i][j] = piece;

func spawn_ice():
	for i in ice_spaces.size():
		emit_signal("make_ice", ice_spaces[i])

func spawn_locks():
	for i in lock_pieces.size():
		emit_signal("make_locks", lock_pieces[i])

func spawn_concrete():
	for i in concrete_pieces.size():
		emit_signal("make_concrete", concrete_pieces[i])

func spawn_slime():
	for i in slime_pieces.size():
		emit_signal("make_slime", slime_pieces[i])

func match_at(i, j, color):
	if i > 1:
		if all_pieces[i - 1][j] != null && all_pieces[i - 2][j] != null:
			if all_pieces[i - 1][j].color == color && all_pieces[i - 2][j].color == color:
				return true;
	if j > 1:
		if all_pieces[i][j-1] != null && all_pieces[i][j-2] != null:
			if all_pieces[i ][j-1].color == color && all_pieces[i][j-2].color == color:
				return true;

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column;
	var new_y = y_start + -offset * row;
	return Vector2(new_x, new_y);

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset);
	var new_y = round((pixel_y - y_start) / -offset);
	return Vector2(new_x, new_y);
	pass;

func is_in_grid(grid_position):
	if grid_position.x >= 0 && grid_position.x < width:
		if grid_position.y >= 0 && grid_position.y < height:
			return true;
	return false;

func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)):
			first_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y);
			controlling = true
	if Input.is_action_just_released("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)) && controlling:
			controlling = false;
			final_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)
			touch_difference(first_touch, final_touch);

func swap_pieces(column, row, direction):
	var first_piece = all_pieces[column][row];
	var other_piece = all_pieces[column + direction.x][row + direction.y];
	if first_piece != null && other_piece != null:
		if !is_in_locks(Vector2(column, row)) && !is_in_locks(Vector2(column + direction.x, row + direction.y)):
			store_info(first_piece, other_piece, Vector2(column, row), direction)
			state = wait
			all_pieces[column][row] = other_piece;
			all_pieces[column + direction.x][row + direction.y] = first_piece;
			first_piece.move(grid_to_pixel(column + direction.x, row + direction.y));
			other_piece.move(grid_to_pixel(column, row));
			if !move_checked:
				find_matches()

func store_info(first_piece, other_piece, place, direction):
	piece_one = first_piece
	piece_two = other_piece
	last_place = place
	last_direction = direction
	pass

func swap_back():
	# Move the previously swapped pieces back to the previous place.
	if piece_one != null && piece_two != null:
		swap_pieces(last_place.x, last_place.y, last_direction) 
	state = move
	move_checked = false
	pass

func touch_difference(grid_1, grid_2):
	var difference = grid_2 - grid_1;
	if abs(difference.x) > abs(difference.y):
		if difference.x > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(1, 0));
		elif difference.x < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(-1, 0));
	elif abs(difference.y) > abs(difference.x):
		if difference.y > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, 1));
		elif difference.y < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, -1));

func _process(delta):
	if state == move:
		touch_input();

func find_matches():
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				var current_color = all_pieces[i][j].color
				if i > 0 && i < width - 1:
					if all_pieces[i - 1][j] != null && all_pieces[i + 1][j] != null:
						if all_pieces[i - 1][j].color == current_color && all_pieces[i + 1][j].color == current_color:
							all_pieces[i - 1][j].matched = true;
							all_pieces[i - 1][j].dim();
							all_pieces[i][j].matched = true;
							all_pieces[i][j].dim();
							all_pieces[i + 1][j].matched = true;
							all_pieces[i + 1][j].dim();
				if j > 0 && j < height - 1:
					if all_pieces[i][j-1] != null && all_pieces[i][j + 1] != null:
						if all_pieces[i][j - 1].color == current_color && all_pieces[i][j + 1].color == current_color:
							all_pieces[i][j - 1].matched = true;
							all_pieces[i][j - 1].dim();
							all_pieces[i][j].matched = true;
							all_pieces[i][j].dim();
							all_pieces[i][j + 1].matched = true;
							all_pieces[i][j + 1].dim();
	get_parent().get_node("destroy_timer").start()

func destroy_matched():
	var was_matched = false
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if all_pieces[i][j].matched:
					emit_signal("damage_ice", Vector2(i,j))
					emit_signal("damage_locks", Vector2(i,j))
					destroy_concrete(i, j)
					destroy_slime(i, j)
					was_matched = true
					all_pieces[i][j].queue_free()
					all_pieces[i][j] = null
	move_checked = true
	if !slime_damaged:
		generate_slime()
	if was_matched:
		get_parent().get_node("collapse_timer").start()
	else:
		swap_back()

func collapse_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null && !restricted_movement(Vector2(i,j)):
				for k in range(j + 1, height):
					if all_pieces[i][k] != null:
						all_pieces[i][k].move(grid_to_pixel(i, j))
						all_pieces[i][j] = all_pieces[i][k]
						all_pieces[i][k] = null
						break
	get_parent().get_node("refill_timer").start()

func refill_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null && !restricted_movement(Vector2(i,j)):
				#choose a random number and store it
				var rand = floor(rand_range(0, possible_pieces.size()));
				var piece = possible_pieces[rand].instance();
				var loops = 0;
				while(match_at(i, j, piece.color) && loops < 100):
					rand = floor(rand_range(0, possible_pieces.size()));
					loops += 1;
					piece = possible_pieces[rand].instance();
				# Instance that piece from the array
				add_child(piece);
				piece.position = grid_to_pixel(i, j + y_offset);
				piece.move(grid_to_pixel(i,j))
				all_pieces[i][j] = piece;
	after_refill()

func after_refill():
	slime_damaged = true
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if match_at(i, j, all_pieces[i][j].color):
					find_matches()
					get_parent().get_node("destroy_timer").start()
					return
	state = move
	move_checked = false
	slime_damaged = false

func _on_destroy_timer_timeout():
	destroy_matched()

func _on_collapse_timer_timeout():
	collapse_columns()

func _on_refill_timer_timeout():
	refill_columns()

func destroy_concrete(column, row):
	if is_in_grid(Vector2(column + 1, row)):
		if(is_in_concrete(Vector2(column + 1, row))):
			emit_signal("damage_concrete", Vector2(column + 1, row))
	if is_in_grid(Vector2(column - 1, row)):
		if(is_in_concrete(Vector2(column - 1, row))):
			emit_signal("damage_concrete", Vector2(column - 1, row))
	if is_in_grid(Vector2(column + 1, row)):
		if(is_in_concrete(Vector2(column, row + 1))):
			emit_signal("damage_concrete", Vector2(column, row + 1))
	if is_in_grid(Vector2(column + 1, row)):
		if(is_in_concrete(Vector2(column, row - 1))):
			emit_signal("damage_concrete", Vector2(column, row - 1))

func destroy_slime(column, row):
	if is_in_grid(Vector2(column + 1, row)):
		if(is_in_slime(Vector2(column + 1, row))):
			emit_signal("damage_slime", Vector2(column + 1, row))
			slime_damaged = true
	if is_in_grid(Vector2(column - 1, row)):
		if(is_in_slime(Vector2(column - 1, row))):
			emit_signal("damage_slime", Vector2(column - 1, row))
			slime_damaged = true
	if is_in_grid(Vector2(column + 1, row)):
		if(is_in_slime(Vector2(column, row + 1))):
			emit_signal("damage_slime", Vector2(column, row + 1))
			slime_damaged = true
	if is_in_grid(Vector2(column + 1, row)):
		if(is_in_slime(Vector2(column, row - 1))):
			emit_signal("damage_slime", Vector2(column, row - 1))
			slime_damaged = true

func generate_slime():
	# Do any slime pieces exist?
	if slime_pieces.size() > 0:
		var made_slime = false
		while !made_slime:
			# Check a random slime piece
			var piece = floor(rand_range(0, slime_pieces.size()))
			# Check to see if this piece has a normal neighbor
			var place = find_normal_neighbor(slime_pieces[piece])
			if place != Vector2(0, 0):
				# turn this piece into a slime
				all_pieces[place.x][place.y].queue_free()
				all_pieces[place.x][place.y] = null
				slime_pieces.append(Vector2(place.x,place.y))
				emit_signal("make_slime", Vector2(place.x,place.y))
				made_slime = true

func find_normal_neighbor(place):
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i!= 0 && j != 0:
				if is_in_grid(Vector2(place.x + i, place.y + j)):
					if all_pieces[place.x + i][place.y + j] != null:
						return Vector2(place.x + i, place.y + j)
	return Vector2(0, 0)

func _on_locks_holder_remove_lock(place):
	for i in lock_pieces.size():
		if lock_pieces[i] == place:
			lock_pieces.remove(i)
			break

func _on_concrete_holder_remove_concrete(place):
	for i in concrete_pieces.size():
		if concrete_pieces[i] == place:
			concrete_pieces.remove(i)
			break

func _on_slime_holder_remove_slime(place):
	for i in slime_pieces.size():
		if slime_pieces[i] == place:
			slime_pieces.remove(i)
			break

func _on_slime_holder_make_slime():
	pass
