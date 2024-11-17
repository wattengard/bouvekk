extends Node2D

@export var life_scene: PackedScene
signal player_dead
signal lost_life

var lives = []
var lives_left = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(lives_left):
		var life = life_scene.instantiate()
		life.position = Vector2(i * 80,0)
		add_child(life)
		lives.append(life)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func kill():
	lost_life.emit()
	lives_left -= 1 
	lives[lives_left].play()
	if (lives_left <= 0):
		player_dead.emit()

func revive():
	lives_left = 3
	for life in lives:
		life.frame = 0
		
