extends Node2D

export (int) var health
var matched = false

func _ready():
	pass

func take_damage(damage):
	health -= damage
	if health <= 0:
		matched = true
	# Can add damage effect here
