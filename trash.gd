extends RigidBody2D
signal hit(amount: int)

var shots_required = 1
var typeToUse
var score_multiplier = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var types = $TrashSprite.sprite_frames.get_animation_names()
	typeToUse = types[randi() % types.size()]
	if typeToUse == "garbag":
		shots_required = 2
	$TrashSprite.play(typeToUse)
	var scale = randf_range(0.5, 1)
	var scaleMod = Vector2(scale, scale)
	$TrashSprite.apply_scale(scaleMod)
	$CollisionShape2D.apply_scale(scaleMod)
	score_multiplier = 1 / scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if typeToUse == "garbag":
		$Trashcrumple.play()
		hit.emit(floor(500 * score_multiplier))
	else:
		$Pshhh.play()
		hit.emit(floor(100 * score_multiplier))
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
