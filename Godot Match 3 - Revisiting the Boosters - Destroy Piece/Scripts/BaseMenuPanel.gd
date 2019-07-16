extends CanvasLayer

func slide_in():
	$AnimationPlayer.play("slide_in")

func slide_out():
	$AnimationPlayer.play_backwards("slide_in")
