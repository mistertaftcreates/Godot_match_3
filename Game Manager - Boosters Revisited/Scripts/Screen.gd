extends TextureRect

onready var fade_tween = $FadeTween


func _ready():
	modulate = Color(1, 1, 1, 0)


func fade_in():
	fade_tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), 
	Color(1, 1, 1, 1), 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	fade_tween.start()


func fade_out():
	fade_tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), 
	Color(1, 1, 1, 0), 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	fade_tween.start()

func _on_GameManager_screen_fade_in():
	fade_tween.stop_all()
	fade_in()


func _on_GameManager_screen_fade_out():
	fade_tween.stop_all()
	fade_out()
