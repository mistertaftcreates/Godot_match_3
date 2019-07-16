extends TextureButton

enum {add_to_counter, make_color_bomb, destroy_piece}
var state

var active = false

# Texture Stuff
var active_texture
export (Texture) var add_to_counter_texture
export (Texture) var make_color_bomb_texture
export (Texture) var destroy_piece_texture
var type = ""


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func check_active(is_active, booster_type):
	if is_active:
		if booster_type == "Color Bomb":
			texture_normal = make_color_bomb_texture
			type = "Color Bomb"
		elif booster_type == "Add To Counter":
			texture_normal = add_to_counter_texture
			type = "Add To Counter"
		elif booster_type == "Destroy Piece":
			texture_normal = destroy_piece_texture
			type = "Destroy Piece"
	else:
		texture_normal = null
		type = ""

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
