extends RigidBody2D
signal shark_escaped
signal shark_was_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_mask_value(2, false)
	$AnimatedSprite2D.play("underwater")
	$UnderTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func go_under():
	set_collision_mask_value(2, false)
	$UnderTimer.wait_time = randf_range(2, 4)
	$AnimatedSprite2D.animation = "underwater"
	$UnderTimer.start()

func go_over():
	set_collision_mask_value(2, true)
	$OverTimer.wait_time = randf_range(0.4, 1)
	$AnimatedSprite2D.animation = "overwater"
	$OverTimer.start()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	shark_escaped.emit()
	#queue_free()


func shark_hit(body: Node):
	shark_was_hit.emit()
	queue_free()
