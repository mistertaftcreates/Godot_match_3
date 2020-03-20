extends "res://Scripts/BaseMenuPanel.gd"

signal sound_change
signal back_button
export (Texture) var sound_on
export (Texture) var sound_off

func _on_Button_1_pressed():
	ConfigManager.sound_on = !ConfigManager.sound_on
	change_sound_texture()
	ConfigManager.save_config()
	SoundManager.set_volume()
	SoundManager.play_fixed_sound(0)

func change_sound_texture():
	if ConfigManager.sound_on == true:
		$"MarginContainer/Graphic and Buttons/Buttons/Button 1".texture_normal = sound_on
	else:
		$"MarginContainer/Graphic and Buttons/Buttons/Button 1".texture_normal = sound_off

func _on_Button_2_pressed():
	SoundManager.play_fixed_sound(0)
	emit_signal("back_button")

func _on_Game_Menu_read_sound():
	change_sound_texture()
