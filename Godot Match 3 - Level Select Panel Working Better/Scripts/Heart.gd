extends TextureRect

onready var lives_number = $LivesNumber
onready var lives_timer = $LivesTimerLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_lives()

func setup_lives():
	lives_number.text = String(LivesManager.lives)
	if LivesManager.lives < LivesManager.max_lives:
		start_life_timer()
	else:
		lives_timer.visible = false

func start_life_timer():
	lives_timer.text = String(LivesManager.set_life_timer())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
