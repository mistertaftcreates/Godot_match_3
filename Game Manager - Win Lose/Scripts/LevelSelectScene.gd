extends CanvasLayer


var scroll_value = 0


func _ready():
	yield(get_tree(), "idle_frame")
	$ScrollContainer.scroll_vertical = GameDataManager.level_scroll_value


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Scenes/Game Menu.tscn")


func _on_LevelBackdrop_save_scroll_value():
	# set the global scroll value to the current scroll value
	var current_scroll_value = $ScrollContainer.scroll_vertical
	GameDataManager.level_scroll_value = current_scroll_value
