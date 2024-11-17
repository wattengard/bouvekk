extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SplashScreen.set_visible(true)
	$Main.set_visible(false)
	$GameOver.set_visible(false)
	
func start_game():
	if $Main.visible == true:
		return
	$SplashScreen.set_visible(false)
	$Main.set_visible(true)
	$Main.start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_over_quit_game() -> void:
	$GameOver.set_visible(false)
	$SplashScreen.set_visible(true)


func _on_main_close_main(score: int) -> void:
	$Main.set_visible(false)
	$GameOver.update_final_score(score)
	$GameOver.set_visible(true)
	pass # Replace with function body.
