extends "res://Scripts/Piece.gd"

export var max_health := 1
export var can_fall := true

var current_health


# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func destroy():
	# Put in a destroy effect
	# reparent the destroy effect to the main scene
	#self.queue_free()
	matched = true


func total_damage():
	current_health = 0
	destroy()


func damage(damage_amount):
	current_health -= damage_amount
	if current_health <= 0:
		destroy()


func heal(heal_amount):
	current_health += heal_amount
	if current_health > max_health:
		current_health = max_health


