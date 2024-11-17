extends Node
@export var trash_scene: PackedScene
@export var shot_scene: PackedScene
@export var shark_scene: PackedScene
@export var hud: PackedScene

signal close_main(score: int)

var maxTimeBetweenSharks = 10
var timeSinceLastShark = 0
var score = 0
var lives = 3
var default_player_position

var trash_on_screen = []
var sharks_on_screen = []
var cruiseship_active = false
var trash_thrown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_player_position = $Player.position
	$HUD.set_visible(false)

func start_game():
	$Timers/TrashTimer.start()
	$Timers/SharkSpawnTimer.start()
	$Timers/CruiseBoatTimer.start()
	$Audio/BGM.play()
	$HUD.set_visible(true)
	update_score(-score)
	$HUD/Lives.revive()
	$Player.position = default_player_position
	$Player/Penguin.scale = Vector2(.5, .5)
	$"Player/Gønner".scale = Vector2(0.19, 0.19)
	$"Player/Gønner".position = Vector2(-14, 12.5)
	$"Player/Gønner".set_visible(true)
	$Player.revive()
	$Cruiseship/CruiseshipScene.show()
	cruiseship_active = false
	trash_thrown = false

func end_game():
	$Timers/TrashTimer.stop()
	$Timers/SharkSpawnTimer.stop()
	$Timers/CruiseBoatTimer.stop()
	$HUD.set_visible(false)
	
	for trash in trash_on_screen:
		if trash != null:
			trash.queue_free()
	for shark in sharks_on_screen:
		if shark != null:
			shark.queue_free()
	cruiseship_active = false
	$Cruiseship/CruiseshipScene.hide()
	$Cruiseship/CruisePath/CruisePathFollow.progress_ratio = 0
	$Cruiseship/CruiseshipScene.position = $Cruiseship/CruisePath/CruisePathFollow.position
	$Cruiseship/CruiseshipScene.flip_h = true
	$"Player/Gønner".visible = false
	$Player.position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	$Player/Penguin.scale = Vector2(8, 8)
	$Player.die()
	$Audio/BGM.stop()
	$Audio/GameOver.play()
	$Timers/EndGameTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("fire_1") && $Timers/ShotLimitTimer.is_stopped()):
		$Timers/ShotLimitTimer.start()
		var new_shot = shot_scene.instantiate()
		new_shot.position = $"Player/Gønner".global_position + Vector2($"Player/Gønner".get_rect().size.x / 2, -12)
		new_shot.linear_velocity = Vector2(2000, 0)
		add_child(new_shot)

	if cruiseship_active:
		update_cruiseship()

func update_cruiseship():
	$Cruiseship/CruisePath/CruisePathFollow.progress_ratio += 0.0005
	if $Cruiseship/CruisePath/CruisePathFollow.progress_ratio > 0.5 and not trash_thrown:
		trash_thrown = true
		$Cruiseship/CruiseshipScene.flip_h = false
		throw_trash($Cruiseship/CruiseshipScene.position)
	if $Cruiseship/CruisePath/CruisePathFollow.progress_ratio == 1:
		trash_thrown = false
		cruiseship_active = false
		$Cruiseship/CruiseshipScene.flip_h = true
	$Cruiseship/CruiseshipScene.position = $Cruiseship/CruisePath/CruisePathFollow.position

func spawn_trash(position: Vector2):
	var trash = trash_scene.instantiate()
	trash.name = "trump"
	trash.position = position
	var velocity = Vector2(-randf_range(150.0, 250.0), 0.0)
	trash.linear_velocity = velocity
	trash.connect("hit", update_score)
	add_child(trash)
	trash_on_screen.append(trash)


func _on_trash_timer_timeout() -> void:
	var trash_spawn_location = $TrashSpawnPath/TrashSpawnLocation
	trash_spawn_location.progress_ratio = randf()
	spawn_trash(trash_spawn_location.position)

func _on_shark_spawn_timer_timeout() -> void:
	if randf() < 0.75 and timeSinceLastShark != maxTimeBetweenSharks:
		timeSinceLastShark += 1
		return
	
	timeSinceLastShark = 0
	
	var shark = shark_scene.instantiate()
	
	var shark_spawn_location = $SharkSpawnPath/SharkSpawnLocation
	shark_spawn_location.progress_ratio = randf()
	var spawnPosition = shark_spawn_location.position
	var velocity = Vector2(randf_range(50.0, 150.0), 0.0)
	var rotation = randi_range(10, 80) + 45
	if randi_range(1, 2) == 1:
		spawnPosition.y = -11
		velocity = velocity.rotated(deg_to_rad(rotation))
		shark.rotation = deg_to_rad(rotation)
	else:
		velocity = velocity.rotated(deg_to_rad(-rotation))
		shark.rotation = deg_to_rad(-rotation)
	
	shark.position = spawnPosition
	shark.linear_velocity = velocity
	shark.connect("shark_was_hit", shark_hit)
	add_child(shark)
	sharks_on_screen.append(shark)

func update_score(amount: int):
	score += amount
	$HUD/Score.text = "Score %s" % score


func _on_hud_player_dead() -> void:
	end_game()

func shark_hit():
	$Audio/SharkHit.play()
	$HUD/Lives.kill()


func _on_bouvetøya_hit() -> void:
	$Audio/TrashOnLand.play()

func throw_trash(current_position: Vector2):
	for i in range(randi_range(5, 10)):
		var angle_from_cruse = randf_range(PI / 2,  3 * PI / 2)
		var distance_from_cruse = randf_range(75, 300)
		var x = cos(angle_from_cruse) * distance_from_cruse
		var y = sin(angle_from_cruse) * distance_from_cruse
		spawn_trash(current_position + Vector2(x, y))


func _on_cruise_boat_timer_timeout() -> void:
	cruiseship_active = true
	$Audio/Cruiseboat.play()
	$Cruiseship/CruisePath/CruisePathFollow.progress_ratio = 0


func _on_end_game_timer_timeout() -> void:
	close_main.emit(score)


func _on_hud_lost_life() -> void:
	$Audio/LostLife.play()
