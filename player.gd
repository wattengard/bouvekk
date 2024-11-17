extends Node2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var player_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_dead:
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$Penguin.play()
	else:
		$Penguin.stop()
		$"Gønner".rotation = 0
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func die():
	player_dead = true
	$Penguin.play("ded")

func revive():
	player_dead = false
	$Penguin.play("walk")

func _on_penguin_frame_changed() -> void:
	if not player_dead:
		if ($Penguin.frame == 0 || $Penguin.frame == 2):
			$"Gønner".rotation = 0
		elif ($Penguin.frame == 1):
			$"Gønner".rotation_degrees = -45
		elif ($Penguin.frame == 3):
			$"Gønner".rotation_degrees = 45
	elif player_dead:
		if ($Penguin.frame == 4):
			$Penguin.pause()
