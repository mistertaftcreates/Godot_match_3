extends Node2D

"""
This should be inheritable, too
"""

export (int) var health
export (bool) var takes_damage

func take_damage(damage):
	if takes_damage:
		health -= damage
		change_opacity()
		# Can add damage effect here

func change_opacity():
	var alpha = $Sprite.modulate.a/2
	$Sprite.modulate.a = alpha