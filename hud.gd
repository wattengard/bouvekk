extends CanvasLayer

signal player_dead
signal lost_life

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func garbage_hit_land():
	$Lives.kill()

func report_player_dead():
	player_dead.emit()


func _on_lives_lost_life() -> void:
	lost_life.emit()
