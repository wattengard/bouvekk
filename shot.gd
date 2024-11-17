extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "shot"
	if visible:
		$Piuuu.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
