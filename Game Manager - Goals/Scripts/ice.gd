extends Node2D

export (int) var health

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func take_damage(damage):
	health -= damage
	# Can add damage effect here
