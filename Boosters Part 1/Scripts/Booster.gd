extends TextureButton

enum {add_to_counter, make_color_bomb, destroy_piece}
var state

var active = false
export (Texture) var active_texture


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func check_active(is_active):
	if is_active:
		texture_normal = active_texture
	else:
		texture_normal = null

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
